#!/bin/bash
# Wfuzz Automation Script (Default Output Directory)
# Author: ChatGPT Assistant

if [ -z "$1" ]; then
    echo "Usage: $0 <target_url>"
    echo "Example: $0 http://example.com/"
    exit 1
fi

TARGET=$1
WORDLIST_DIR="/usr/share/wordlists"
COMMON_WORDLIST="$WORDLIST_DIR/dirb/common.txt"
PARAMS_WORDLIST="$WORDLIST_DIR/SecLists/Discovery/Web-Content/burp-parameter-names.txt"
XSS_PAYLOADS="$WORDLIST_DIR/SecLists/Fuzzing/XSS/xss-rsnake.txt"

echo "[*] Starting Wfuzz automation on: $TARGET"
echo "[*] Results will be saved in the current folder."

# ----------------------------
# Directory Bruteforce
# ----------------------------
echo "[*] Running Directory Bruteforce..."
wfuzz -c -z file,$COMMON_WORDLIST --hc 404 $TARGET/FUZZ \
    | tee dirs.txt

# ----------------------------
# Parameter Fuzzing
# ----------------------------
echo "[*] Running Parameter Fuzzing..."
wfuzz -c -z file,$PARAMS_WORDLIST --hh 0 "$TARGET?FUZZ=1" \
    | tee params.txt

# ----------------------------
# XSS Payload Injection
# ----------------------------
echo "[*] Running XSS Fuzzing..."
wfuzz -c -z file,$XSS_PAYLOADS --hh 0 "$TARGET/search.php?q=FUZZ" \
    | tee xss.txt

echo "[*] Scans complete! Check results in current folder:"
echo "  - dirs.txt"
echo "  - params.txt"
echo "  - xss.txt"
