#!/usr/bin/env bash
# Stow or unstow a dotfiles module into $HOME.

set -euo pipefail

# shellcheck source=scripts/lib/common.sh
source "$(dirname "$0")/lib/common.sh"

usage() {
  cat <<'EOF'
Usage: stow-module.sh <module>           Stow module into $HOME
       stow-module.sh -D <module>        Unstow module
       stow-module.sh -R <module>        Restow module
EOF
}

ACTION="-S"
MODULE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -D|-R|-S) ACTION="$1"; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) die "unknown option: $1" ;;
    *)
      [[ -z "$MODULE" ]] || die "unexpected argument: $1"
      MODULE="$1"
      shift
      ;;
  esac
done

[[ -n "$MODULE" ]] || { usage; exit 1; }

require_cmd stow

MOD_DIR="$DOTFILES_ROOT/modules/$MODULE"
[[ -d "$MOD_DIR" ]] || die "module not found: $MODULE"

STOW_DIR="$MOD_DIR/home"
[[ -d "$STOW_DIR" ]] || die "module has no home/ stow tree: $MODULE"

log "${ACTION#-}towing module: $MODULE"
stow -v "$ACTION" -t "$HOME" -d "$STOW_DIR" .

if [[ -x "$MOD_DIR/install.sh" && "$ACTION" != "-D" ]]; then
  log "running module install hook: $MODULE"
  DOTFILES_PROFILE="${DOTFILES_PROFILE:-work.mac}" \
    "$MOD_DIR/install.sh"
fi

printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$MODULE" >>"$DOTFILES_STATE_DIR/stowed-modules.log"
