#!/usr/bin/env bash
# macOS CI: запускает integration-тест на симуляторе с watchdog.
# Бывает «тихое» зависание между сборкой Xcode и началом теста (результат не
# печатается вообще). Нормальный прогон после сборки занимает около минуты.
# Повторяем ТОЛЬКО при таком зависании (код 124); реальное падение теста
# (код != 0/124) не повторяется и не маскируется.
# Требует: SIM_UDID, SIM_NAME, SIM_OS. Аргумент: время одной попытки в секундах.
set -uo pipefail
attempt_seconds="${1:-720}"
max_attempts=2

run_attempt() {
  python3 -I - "$attempt_seconds" <<'PY'
import os, signal, subprocess, sys
limit = int(sys.argv[1])
cmd = ["flutter", "test", "integration_test/r1_smoke_test.dart", "-d", os.environ["SIM_UDID"],
       "--dart-define=TEST_DEVICE=Simulator_" + os.environ["SIM_NAME"],
       "--dart-define=TEST_OS=iOS_" + os.environ["SIM_OS"]]
p = subprocess.Popen(cmd, start_new_session=True)
try:
    sys.exit(p.wait(timeout=limit))
except subprocess.TimeoutExpired:
    os.killpg(p.pid, signal.SIGKILL)
    p.wait()
    sys.exit(124)
PY
}

for attempt in $(seq 1 "$max_attempts"); do
  echo "::group::integration test, attempt $attempt of $max_attempts"
  run_attempt; rc=$?
  echo "::endgroup::"
  if [[ $rc -eq 0 ]]; then
    ((attempt > 1)) && echo "::warning::Simulator test passed only on attempt $attempt (attempt 1 hung silently)"
    exit 0
  fi
  if [[ $rc -ne 124 ]]; then
    echo "::error::integration test failed with exit code $rc (not a hang, not retried)"
    exit "$rc"
  fi
  echo "::warning::attempt $attempt produced no result within ${attempt_seconds}s (silent hang); collecting simulator diagnostics"
  {
    echo "--- simctl devices"; xcrun simctl list devices booted
    echo "--- Runner log, last 10 min"
    xcrun simctl spawn "$SIM_UDID" log show --last 10m --style compact \
      --predicate 'process == "Runner"' 2>&1 | tail -80
    echo "--- crash reports"; ls -la ~/Library/Logs/DiagnosticReports 2>&1 | tail -10
  } || true
  pkill -f xcodebuild 2>/dev/null || true
done
echo "::error::integration test hung on every attempt"
exit 124
