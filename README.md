# Wfuzz-Bash-automation-script
Awesome 👍 Let’s make this script smarter.
We’ll **automatically detect parameters first**, then run SQLi & LFI fuzzing against them.

The workflow will be:

1. **Directory brute-force** (as before).
2. **Find GET parameters** in the target (`waybackurls` + `gau` + `grep`).
3. For each discovered parameter, run:

   * SQLi fuzzing
   * LFI fuzzing
4. Save results into the current folder.

---


## 🔹 Setup Requirements

Install **SecLists** (for payloads):

```bash
sudo apt install seclists -y
```

Install **gau** + **waybackurls** (for parameter discovery):

```bash
go install github.com/tomnomnom/gau@latest
go install github.com/tomnomnom/waybackurls@latest
```

(Ensure `$GOPATH/bin` is in your `$PATH`)

---

## 🔹 Usage

```bash
chmod +x wfuzz-auto.sh
```
```bash
./wfuzz-auto.sh target.com
```
---

## 🔹 Output

* `dirs.txt` → Directory brute-force results
* `params.txt` → Discovered parameterized URLs
* `sqli.txt` → SQL injection fuzzing results
* `lfi.txt` → LFI fuzzing results

---

⚡ This script **first finds real parameters**, then injects SQLi & LFI payloads, so it’s much smarter than static testing.


