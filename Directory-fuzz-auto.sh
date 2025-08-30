#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <target_url>"
    echo "Example: $0 http://example.com/"
    exit 1
fi

TARGET=$1
WORDLIST_DIR="/usr/share/wordlists"
COMMON_WORDLIST="$WORDLIST_DIR/dirb/common.txt"

echo "[*] Starting Wfuzz automation on: $TARGET"
echo "[*] Results will be saved in the current folder."

# ----------------------------
# Directory Bruteforce
# ----------------------------
echo "[*] Running Directory Bruteforce..."
wfuzz -c -z file,$COMMON_WORDLIST --hc 404 $TARGET/FUZZ \
    | tee dirs.txt

echo "[*] Scans complete! Check results in current folder:"
echo "  - dirs.txt"

