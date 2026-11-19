#!/usr/bin/env bash
set -euo pipefail

AGENTS_REPO="https://github.com/JRedOW/.agents.git"
AGENTS_DIR="${AGENTS_HUB:-$HOME/.agents}"

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

command -v git >/dev/null 2>&1 || die "git is required"

if [ -d "$AGENTS_DIR" ] && [ ! -d "$AGENTS_DIR/.git" ]; then
  die "$AGENTS_DIR exists but is not a git checkout"
fi

if [ ! -d "$AGENTS_DIR/.git" ]; then
  git clone "$AGENTS_REPO" "$AGENTS_DIR"
fi

if ! command -v jq >/dev/null 2>&1; then
  command -v apt-get >/dev/null 2>&1 || die "jq is required; install it and rerun"
  if [ "$(id -u)" -eq 0 ]; then
    apt-get update
    apt-get install -y jq
  elif command -v sudo >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y jq
  else
    die "jq is required; run as root or install sudo, then rerun"
  fi
fi

"$AGENTS_DIR/scripts/link.sh"

marker="# >>> .agents aliases >>>"
source_line="[ -f \"$AGENTS_DIR/scripts/profiles.sh\" ] && . \"$AGENTS_DIR/scripts/profiles.sh\""

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  touch "$rc"
  if ! grep -qF "$marker" "$rc"; then
    printf '\n%s\n%s\n# <<< .agents aliases <<<\n' "$marker" "$source_line" >> "$rc"
  fi
done
