#!/usr/bin/env bash
# macOS: выбирает доступный iPhone-симулятор самой новой iOS и печатает «UDID|имя|iOS-версия».
set -euo pipefail
xcrun simctl list -j devices available | python3 -I -c '
import json, sys
data = json.load(sys.stdin)["devices"]
best = None
for runtime, devices in data.items():
    if ".iOS-" not in runtime:
        continue
    version = tuple(int(p) for p in runtime.rsplit(".iOS-", 1)[1].split("-"))
    for d in devices:
        if d["name"].startswith("iPhone") and d.get("isAvailable", True):
            cand = (version, d["name"], d["udid"])
            if best is None or cand > best:
                best = cand
if best is None:
    sys.exit("No available iPhone simulator found")
version, name, udid = best
print("%s|%s|%s" % (udid, name, ".".join(str(p) for p in version)))
'
