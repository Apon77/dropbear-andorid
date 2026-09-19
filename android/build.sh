#!/usr/bin/env bash
# Run from anywhere. Needs: NDK=/path/to/ndk/<version>
set -euo pipefail
cd "$(dirname "$0")/.."
: "${NDK:?set NDK=/path/to/ndk/<version>}"
API="${API:-24}"
TC="$NDK/toolchains/llvm/prebuilt/$(uname -s | tr A-Z a-z)-x86_64/bin"
export CC="$TC/aarch64-linux-android$API-clang" AR="$TC/llvm-ar" RANLIB="$TC/llvm-ranlib" STRIP="$TC/llvm-strip"

make distclean >/dev/null 2>&1 || true        # the "make clean" step you needed
./configure --host=aarch64-linux-android --disable-zlib \
  --disable-utmp --disable-wtmp --disable-utmpx --disable-wtmpx \
  --disable-lastlog --disable-pututline --disable-pututxline
make PROGRAMS="dropbear dropbearkey" -j"$(getconf _NPROCESSORS_ONLN)"
"$STRIP" dropbear dropbearkey
file dropbear
