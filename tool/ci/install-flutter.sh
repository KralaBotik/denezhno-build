#!/usr/bin/env bash
# Ставит Flutter SDK версии из .flutter-version в $RUNNER_TEMP/flutter (или в каталог $1)
# и добавляет его в PATH следующих шагов GitHub Actions.
# Источник — официальный репозиторий flutter/flutter по тегу; затем проверяется, что
# тег указывает на ожидаемый коммит $FLUTTER_COMMIT (защита от переписанного тега).
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
version="$(tr -d '[:space:]' < "$root/.flutter-version")"
: "${FLUTTER_COMMIT:?FLUTTER_COMMIT must be set (full commit hash of the pinned tag)}"
dest="${1:-${RUNNER_TEMP:?}/flutter}"

git clone --quiet --depth 1 --branch "$version" https://github.com/flutter/flutter.git "$dest"
actual="$(git -C "$dest" rev-parse HEAD)"
if [[ "$actual" != "$FLUTTER_COMMIT" ]]; then
  echo "Flutter tag $version resolves to $actual, expected $FLUTTER_COMMIT" >&2
  exit 1
fi

export PATH="$dest/bin:$PATH"
export FLUTTER_SUPPRESS_ANALYTICS=true DART_SUPPRESS_ANALYTICS=true
flutter --suppress-analytics --version
reported="$(flutter --suppress-analytics --version --machine | python3 -I -c 'import json,sys; print(json.load(sys.stdin)["frameworkVersion"])')"
if [[ "$reported" != "$version" ]]; then
  echo "Installed Flutter $reported, expected $version" >&2
  exit 1
fi
if [[ -n "${GITHUB_PATH:-}" ]]; then
  echo "$dest/bin" >> "$GITHUB_PATH"
fi
