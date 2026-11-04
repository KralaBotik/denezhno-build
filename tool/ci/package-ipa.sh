#!/usr/bin/env bash
# macOS only. Упаковывает НЕПОДПИСАННЫЙ Runner.app в .ipa для последующей подписи
# на стороне пользователя (Sideloadly) и проверяет состав готового архива.
#   package-ipa.sh <Runner.app> <out.ipa> <report.txt>
# Никаких Apple ID, сертификатов и профилей здесь нет и быть не должно.
set -euo pipefail
app="$1"; ipa="$2"; report="$3"
expected_min_os="16.0"
expected_bundle_id="app.denezhno.denezhno"

[[ -d "$app" ]] || { echo "No such app: $app" >&2; exit 1; }
mkdir -p "$(dirname "$ipa")" "$(dirname "$report")"
ipa="$(cd "$(dirname "$ipa")" && pwd)/$(basename "$ipa")"
rm -f "$ipa"
work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT

mkdir "$work/pack/" "$work/pack/Payload"
ditto "$app" "$work/pack/Payload/Runner.app"   # сохраняет symlinks и атрибуты
(cd "$work/pack" && zip -qry -X "$ipa" Payload)

# Все проверки выполняются над УЖЕ готовым .ipa, а не над исходным каталогом.
mkdir "$work/check"; unzip -q "$ipa" -d "$work/check"
root="$work/check/Payload/Runner.app"
failures=()
fail() { failures+=("$1"); echo "FAIL: $1"; }

{
echo "## IPA"
echo "file: $(basename "$ipa")  size: $(du -k "$ipa" | cut -f1) KiB"
echo "sha256: $(shasum -a 256 "$ipa" | cut -d' ' -f1)"
echo
echo "## Top-level entries (must be Payload only)"
top="$(unzip -Z1 "$ipa" | cut -d/ -f1 | sort -u)"; echo "$top"
[[ "$top" == "Payload" ]] || fail "unexpected top-level entries in IPA"

echo; echo "## Main Info.plist"
plist="$root/Info.plist"
for key in CFBundleIdentifier CFBundleExecutable CFBundleShortVersionString CFBundleVersion \
           MinimumOSVersion DTPlatformName DTSDKName UIDeviceFamily UIRequiredDeviceCapabilities; do
  printf '%s = ' "$key"; /usr/libexec/PlistBuddy -c "Print :$key" "$plist" 2>/dev/null | tr '\n' ' ' || true; echo
done
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$plist")" == "$expected_bundle_id" ]] \
  || fail "bundle id differs from $expected_bundle_id"
[[ "$(/usr/libexec/PlistBuddy -c 'Print :MinimumOSVersion' "$plist")" == "$expected_min_os" ]] \
  || fail "MinimumOSVersion is not $expected_min_os"
[[ "$(/usr/libexec/PlistBuddy -c 'Print :DTPlatformName' "$plist")" == "iphoneos" ]] \
  || fail "DTPlatformName is not iphoneos (simulator build?)"

echo; echo "## Provisioning / signature artefacts"
find "$root" -name 'embedded.mobileprovision' | sed "s|$root/||"
[[ -z "$(find "$root" -name 'embedded.mobileprovision')" ]] || fail "embedded.mobileprovision present"
find "$root" -name '_CodeSignature' | sed "s|$root/||" | sed 's/^/_CodeSignature: /'

echo; echo "## Mach-O files"
while IFS= read -r f; do
  rel="${f#"$root/"}"
  echo "-- $rel"
  echo "   archs: $(lipo -archs "$f" 2>&1)"
  platform="$(vtool -show-build "$f" 2>/dev/null | awk '$1=="platform"{print $2; exit}')"
  minos="$(vtool -show-build "$f" 2>/dev/null | awk '$1=="minos"{print $2; exit}')"
  if [[ -z "$platform" ]] && otool -l "$f" 2>/dev/null | grep -q LC_VERSION_MIN_IPHONEOS; then platform="IOS"; fi
  echo "   platform: ${platform:-?}  minos: ${minos:-?}"
  echo "   signature: $(codesign -dv "$f" 2>&1 | grep -E 'Signature|Identifier=|TeamIdentifier|not signed' | tr '\n' ';')"
  ents="$(codesign -d --entitlements :- "$f" 2>/dev/null | tr -d '\n' | head -c 400 || true)"
  echo "   embedded entitlements: ${ents:-none}"
  [[ "$platform" == "IOS" ]] || fail "$rel: platform ${platform:-?} is not IOS"
  [[ "$(lipo -archs "$f")" == "arm64" ]] || fail "$rel: archs are not exactly arm64"
done < <(find "$root" -type f ! -name '*.sh' -exec sh -c 'file "$1" | grep -q "Mach-O" && echo "$1"' _ {} \; | sort)

echo; echo "## Frameworks"
for fw in "$root"/Frameworks/*.framework; do
  name="$(basename "$fw")"
  echo "-- $name  id=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$fw/Info.plist" 2>/dev/null)" \
       " MinimumOSVersion=$(/usr/libexec/PlistBuddy -c 'Print :MinimumOSVersion' "$fw/Info.plist" 2>/dev/null)"
done
for required in Flutter.framework App.framework sqlite3mc.framework; do
  [[ -d "$root/Frameworks/$required" ]] || fail "missing Frameworks/$required"
done

echo; echo "## Dynamic library dependencies of Runner (otool -L)"
otool -L "$root/Runner" | tail -n +2 | awk '{print $1}'

echo; echo "## Privacy manifests"
find "$root" -name PrivacyInfo.xcprivacy | sed "s|$root/||"

echo; echo "## Bundled resources that should not be shipped"
find "$root" \( -name '*.p12' -o -name '*.pem' -o -name '*.key' -o -name '.env*' -o -name '*.sqlite*' \) | sed "s|$root/||"
[[ -z "$(find "$root" \( -name '*.p12' -o -name '*.pem' -o -name '*.key' -o -name '.env*' -o -name '*.sqlite*' \))" ]] \
  || fail "secret-like or database file bundled"

echo; echo "## Diagnostics feature present in the packaged binaries"
check_text() { # <file> <label> <text...>: ищет строку в UTF-8 / UTF-16LE / Latin-1
  python3 -I - "$1" "$2" "${@:3}" <<'PY'
import sys
path, label = sys.argv[1], sys.argv[2]
data = open(path, "rb").read()
for text in sys.argv[3:]:
    found = []
    for enc in ("utf-8", "utf-16-le"):
        if text.encode(enc) in data:
            found.append(enc)
    print("%s: %r -> %s" % (label, text, ",".join(found) or "MISSING"))
    if not found:
        sys.exit(1)
PY
}
app_bin="$root/Frameworks/App.framework/App"
check_text "$app_bin" "Dart AOT" "DENEZHNO-DIAGNOSTICS-V1" "diagnostics.copy" "Скопировать диагностику" \
  || fail "diagnostics feature missing in App.framework/App"
check_text "$root/Runner" "Swift" "protection_mismatch=" "storage_protection_failed" \
  || fail "native diagnostic labels missing in Runner"

echo; echo "## Result"
if ((${#failures[@]})); then printf 'FAILED: %s\n' "${failures[@]}"; else echo "OK"; fi
} 2>&1 | tee "$report"

# Результат проверок живёт внутри блока выше (пайп), поэтому читаем его из отчёта.
if grep -q '^FAILED:' "$report"; then exit 1; fi
