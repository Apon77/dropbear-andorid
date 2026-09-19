Dropbear for non-rooted Android (adb shell user, key login, port 2222).
Based on upstream Dropbear 2026.94.

    export NDK=$HOME/Android/Sdk/ndk/<version>
    android/build.sh
    PUBKEY=~/.ssh/bit.pub android/deploy.sh
    ssh -i ~/.ssh/bit -p 2222 shell@<phone-ip>      # or: adb forward tcp:2222 tcp:2222

Changes vs upstream: src/sshpty.c, src/svr-authpubkey.c, localoptions.h.
