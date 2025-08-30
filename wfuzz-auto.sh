#!/bin/bash
# Wfuzz Automation Script (Dir + Auto Param Detection + SQLi + LFI)

if [ -z "$1" ]; then
    echo "Usage: $0 <target_domain>"
    echo "Example: $0 example.com"
    exit 1
fi

DOMAIN=$1
TARGET="http://$DOMAIN"
WORDLIST_DIR="/usr/share/wordlists"

# Wordlists
COMMON_WORDLIST="$WORDLIST_DIR/dirb/common.txt"
SQLI_PAYLOADS="$WORDLIST_DIR/SecLists/Fuzzing/SQLi/sql-injection.txt"
LFI_PAYLOADS="$WORDLIST_DIR/SecLists/Fuzzing/LFI/LFI-Jhaddix.txt"

echo "[*] Starting Wfuzz automation on: $TARGET"
echo "[*] Results will be saved in the current folder."

# ----------------------------
# Directory Bruteforce
# ----------------------------
echo "[*] Running Directory Bruteforce..."
wfuzz -c -z file,$COMMON_WORDLIST --hc 404 $TARGET/FUZZ \
    | tee dirs.txt

# ----------------------------
# Parameter Discovery
# ----------------------------
echo "[*] Discovering Parameters..."
PARAMS_FILE="params.txt"
> $PARAMS_FILE

# Collect URLs with parameters from Wayback + gau
if command -v waybackurls &>/dev/null; then
    waybackurls $DOMAIN | grep "=" >> $PARAMS_FILE
fi

if command -v gau &>/dev/null; then
    gau $DOMAIN | grep "=" >> $PARAMS_FILE
fi

sort -u -o $PARAMS_FILE $PARAMS_FILE

if [ ! -s $PARAMS_FILE ]; then
    echo "[!] No parameters found automatically. Exiting fuzzing."
    exit 0
fi

echo "[*] Found $(wc -l < $PARAMS_FILE) parameterized URLs."
echo "[*] Results saved in $PARAMS_FILE"

# ----------------------------
# SQL Injection Fuzzing
# ----------------------------
echo "[*] Running SQLi Fuzzing..."
while read -r url; do
    echo "[*] Testing SQLi on $url"
    wfuzz -c -z file,$SQLI_PAYLOADS --hh 0 "$url" \
        | tee -a sqli.txt
done < $PARAMS_FILE

# ----------------------------
# LFI Fuzzing
# ----------------------------
echo "[*] Running LFI Fuzzing..."
while read -r url; do
    echo "[*] Testing LFI on $url"
    wfuzz -c -z file,$LFI_PAYLOADS --hh 0 "$url" \
        | tee -a lfi.txt
done < $PARAMS_FILE

echo "[*] Scans complete! Check results in current folder:"
echo "  - dirs.txt  (directories & files)"
echo "  - params.txt (discovered parameters)"
echo "  - sqli.txt  (SQLi fuzz results)"
echo "  - lfi.txt   (LFI fuzz results)"
