#!/bin/bash

# ===== Colors =====
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
WHITE='\033[1;37m'
RED='\033[0;31m'
RESET='\033[0m'

URL_LOG="shortened_urls.txt"

trap 'echo -e "\n${YELLOW}Exiting Cipher-XSS...${RESET}"; exit 0' INT

banner() {
  clear
  echo -e "${GREEN}"
  echo "      ⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀"
  echo "      ⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷"
  echo "      ⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
  echo "      ⠀⠀⣿⣿⡟⠛⠛⠛⠛⠛⠛⢻⣿⣿"
  echo "      ⠀⠀⣿⣿⡇   MASK    ⣿⣿⣿"
  echo "      ⠀⠀⣿⣿⡇  HACKER   ⣿⣿⣿"
  echo "      ⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
  echo "      ⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏"
  echo -e "${RESET}"
  echo -e "${CYAN}CIPHER-XSS TOOLKIT${RESET}"
  echo -e "${WHITE}⚠ For educational purposes only.${RESET}"
  echo
}

pause() { read -rp "Press Enter to continue..." _; }

hashing_menu() {
  while true; do
    banner
    echo -e "${YELLOW}[Hashing Tools]${RESET}"
    echo "1) MD5"
    echo "2) SHA1"
    echo "3) SHA256"
    echo "4) SHA512"
    echo "5) Back"
    echo
    read -rp "Select: " h
    case "$h" in
      1) read -rp "Enter text: " t; echo -n "$t" | md5sum    | awk '{print $1}'; pause ;;
      2) read -rp "Enter text: " t; echo -n "$t" | sha1sum   | awk '{print $1}'; pause ;;
      3) read -rp "Enter text: " t; echo -n "$t" | sha256sum | awk '{print $1}'; pause ;;
      4) read -rp "Enter text: " t; echo -n "$t" | sha512sum | awk '{print $1}'; pause ;;
      5) return ;;
      *) echo "Invalid option"; sleep 0.8 ;;
    esac
  done
}

encoding_menu() {
  while true; do
    banner
    echo -e "${YELLOW}[Encoding / Decoding]${RESET}"
    echo "1) Base64 Encode"
    echo "2) Base64 Decode"
    echo "3) URL Encode"
    echo "4) URL Decode"
    echo "5) Back"
    echo
    read -rp "Select: " e
    case "$e" in
      1) read -rp "Enter text: " t; echo -n "$t" | base64; pause ;;
      2) read -rp "Enter Base64: " t; out=$(echo -n "$t" | base64 -d 2>/dev/null); rc=$?; if [ $rc -ne 0 ]; then echo "Invalid Base64"; else echo "$out"; fi; pause ;;
      3) read -rp "Enter text: " t; python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.stdin.read().rstrip('\n')))" <<<"$t"; pause ;;
      4) read -rp "Enter URL-encoded text: " t; python3 -c "import urllib.parse,sys; print(urllib.parse.unquote(sys.stdin.read().rstrip('\n')))" <<<"$t"; pause ;;
      5) return ;;
      *) echo "Invalid option"; sleep 0.8 ;;
    esac
  done
}

shortener_menu() {
  while true; do
    banner
    echo -e "${YELLOW}[URL Shortener]${RESET}"
    echo "1) Shorten a URL (TinyURL API)"
    echo "2) View saved shortened URLs"
    echo "3) Back"
    echo
    read -rp "Select: " s
    case "$s" in
      1)
        read -rp "Enter long URL: " long
        if [ -z "$long" ]; then echo "No URL provided."; sleep 0.8; continue; fi
        short=$(curl -fsS "https://tinyurl.com/api-create.php?url=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$long")" 2>/dev/null)
        if [ -z "$short" ]; then
          echo "Shortening failed."
        else
          echo "Shortened: $short"
          printf "%s\t->\t%s\t[%s]\n" "$short" "$long" "$(date '+%Y-%m-%d %H:%M:%S')" >> "$URL_LOG"
          echo "Saved to $URL_LOG"
        fi
        pause
        ;;
      2)
        if [ -s "$URL_LOG" ]; then
          echo
          cat "$URL_LOG"
        else
          echo "No entries yet."
        fi
        echo
        pause
        ;;
      3) return ;;
      *) echo "Invalid option"; sleep 0.8 ;;
    esac
  done
}

main_menu() {
  while true; do
    banner
    echo "1) Hashing Tools"
    echo "2) Encoding / Decoding"
    echo "3) URL Shortener"
    echo "4) Exit"
    echo
    read -rp "Choose an option: " c
    case "$c" in
      1) hashing_menu ;;
      2) encoding_menu ;;
      3) shortener_menu ;;
      4) echo "Goodbye."; exit 0 ;;
      *) echo "Invalid option"; sleep 0.8 ;;
    esac
  done
}

# ===== Pre-flight checks =====
need() { command -v "$1" >/dev/null 2>&1 || { echo -e "${YELLOW}Missing dependency:${WHITE} $1${RESET}"; MISSING=1; }; }
MISSING=0
need md5sum; need sha1sum; need sha256sum; need sha512sum; need base64; need curl; need python3
if [ "$MISSING" = "1" ]; then
  echo -e "${RED}Install the missing dependencies above and re-run.${RESET}"
  exit 1
fi

main_menu
