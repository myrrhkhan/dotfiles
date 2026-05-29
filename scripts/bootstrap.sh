#!/usr/bin/env bash
# Apply a dotfiles profile: stow modules, sketchybar, optional brew questionnaire.

set -euo pipefail

# shellcheck source=scripts/lib/common.sh
source "$(dirname "$0")/lib/common.sh"
# shellcheck source=scripts/lib/manifest.sh
source "$(dirname "$0")/lib/manifest.sh"

export DOTFILES_PROFILE="${DOTFILES_PROFILE:-work.mac}"

usage() {
  cat <<EOF
Usage: DOTFILES_PROFILE=work.mac $(basename "$0") [options]

Options:
  --no-brew       Skip brew questionnaire and module Brewfiles
  --brew-only     Only run brew steps (taps + questionnaire)
  -h, --help      Show help

Profiles live in: $DOTFILES_ROOT/profiles/<name>/manifest.toml
EOF
}

SKIP_BREW=0
BREW_ONLY=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-brew) SKIP_BREW=1; shift ;;
    --brew-only) BREW_ONLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown option: $1" ;;
  esac
done

manifest_path "$DOTFILES_PROFILE" >/dev/null
log "profile: $DOTFILES_PROFILE ($(manifest_get profile.id))"

if [[ "$BREW_ONLY" -eq 0 ]]; then
  HOT_CORNERS="$DOTFILES_ROOT/scripts/hot-corners/install.sh"
  if [[ -x "$HOT_CORNERS" ]]; then
    log "running hot corners"
    "$HOT_CORNERS"
  fi

  while IFS= read -r mod; do
    [[ -n "$mod" ]] || continue
    if [[ "$mod" == sketchybar-* || "$mod" == hot-corners ]]; then
      continue
    fi
    "$DOTFILES_ROOT/scripts/stow-module.sh" -R "$mod"
  done < <(manifest_modules "$DOTFILES_PROFILE")

  "$DOTFILES_ROOT/scripts/sketchybar-switch.sh" --from-manifest
fi

if [[ "$SKIP_BREW" -eq 0 ]]; then
  if [[ -f "$DOTFILES_ROOT/brew/Brewfile.taps" ]]; then
    log "installing taps"
    HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --file="$DOTFILES_ROOT/brew/Brewfile.taps"
  fi

  if [[ -f "$DOTFILES_ROOT/modules/sketchybar-common/Brewfile" ]]; then
    log "sketchybar brew deps"
    HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --file="$DOTFILES_ROOT/modules/sketchybar-common/Brewfile"
  fi

  while IFS= read -r mod; do
    [[ -n "$mod" ]] || continue
    bf="$DOTFILES_ROOT/modules/$mod/Brewfile"
    if [[ -f "$bf" ]]; then
      log "brew bundle: $mod"
      HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --file="$bf"
    fi
  done < <(manifest_modules "$DOTFILES_PROFILE")

  if manifest_get brew.questionnaire.interactive "$DOTFILES_PROFILE"; then
    "$DOTFILES_ROOT/scripts/brew-questionnaire.sh"
  fi
fi

log "bootstrap complete for $DOTFILES_PROFILE"
