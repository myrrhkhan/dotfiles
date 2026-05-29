#!/usr/bin/env bash
# Shared helpers for dotfiles scripts.

set -euo pipefail

DOTFILES_ROOT="${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
export DOTFILES_ROOT

DOTFILES_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
export DOTFILES_STATE_DIR

mkdir -p "$DOTFILES_STATE_DIR"

log() { printf 'dotfiles: %s\n' "$*"; }
warn() { printf 'dotfiles: WARNING: %s\n' "$*" >&2; }
die() { printf 'dotfiles: ERROR: %s\n' "$*" >&2; exit 1; }

require_cmd() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1 || die "required command not found: $cmd"
}
