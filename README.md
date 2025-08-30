# Wfuzz-Bash-automation-script

Perfect 👍 Let’s build a **Bash automation script** for Wfuzz.
This script will:

* Take a **target domain/URL** as input
* Run **directory brute-force**
* Run **parameter fuzzing**
* Try **XSS payloads**
* Save all results into an `out/` folder

---

## 🔹 Usage

1. Save script:

```bash
nano wfuzz-auto.sh
```

(Paste the script above)

2. Make executable:

```bash
chmod +x wfuzz-auto.sh
```

3. Run it:

```bash
./wfuzz-auto.sh http://target.com
```

---

## 🔹 Output

* `out/dirs.txt` → directory brute-force results
* `out/params.txt` → discovered GET parameters
* `out/xss.txt` → possible XSS reflections

---

⚡ Note:

* Needs **SecLists** installed for extra wordlists:

```bash
sudo apt install seclists -y
```

* You can add SQLi/LFI payloads too (same style as XSS).

---

👉 Do you want me to **extend this script with SQLi & LFI fuzzing** so it becomes a full vulnerability scanner?
