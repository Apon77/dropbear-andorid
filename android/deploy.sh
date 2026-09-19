#!/usr/bin/env bash
# Push to phone and start. Run again after every reboot (or to update).
set -euo pipefail
cd "$(dirname "$0")/.."
PUBKEY="${PUBKEY:-$HOME/.ssh/id_ed25519.pub}"; PORT="${PORT:-2222}"; D=/data/local/tmp/db

adb shell "kill \$(cat $D/dropbear.pid) 2>/dev/null; true"
adb shell "mkdir -p $D/ak"
adb push dropbear dropbearkey "$D/"
adb push "$PUBKEY" "$D/ak/authorized_keys"
adb shell "test -f $D/hostkey" || adb shell "$D/dropbearkey -t ed25519 -f $D/hostkey"
adb shell "chmod 755 $D/dropbear $D/dropbearkey; chmod 700 $D $D/ak; chmod 600 $D/ak/authorized_keys $D/hostkey"
adb shell "setsid nohup $D/dropbear -E -s -p $PORT -r $D/hostkey -D $D/ak -P $D/dropbear.pid > $D/log.txt 2>&1 < /dev/null &"
echo "started on port $PORT; log: adb shell cat $D/log.txt"
