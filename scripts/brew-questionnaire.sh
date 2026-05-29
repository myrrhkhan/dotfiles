#!/usr/bin/env bash
# Interactive cask picker driven by manifest brew.groups (gum).

set -euo pipefail

# shellcheck source=scripts/lib/common.sh
source "$(dirname "$0")/lib/common.sh"
# shellcheck source=scripts/lib/manifest.sh
source "$(dirname "$0")/lib/manifest.sh"

export DOTFILES_PROFILE="${DOTFILES_PROFILE:-work.mac}"

require_cmd brew
require_cmd gum

GROUPS_DIR="$DOTFILES_ROOT/brew/groups"
OUT="${DOTFILES_BREWFILE_SELECTED:-${TMPDIR:-/tmp}/Brewfile.selected.$$}"

_collect_casks() {
  local profile="$1" seen="" group file token
  while IFS= read -r group; do
    [[ -n "$group" ]] || continue
    file="$GROUPS_DIR/${group}.txt"
    if [[ ! -f "$file" ]]; then
      warn "brew group not found: $group"
      continue
    fi
    while IFS= read -r token || [[ -n "$token" ]]; do
      token="${token%%#*}"
      token="$(echo "$token" | xargs)"
      [[ -n "$token" ]] || continue
      if [[ " $seen " != *" $token "* ]]; then
        printf '%s\n' "$token"
        seen="$seen $token"
      fi
    done <"$file"
  done < <(manifest_brew_groups "$profile")
}

_build_label() {
  local cask="$1" desc
  desc="$(brew info --cask "$cask" 2>/dev/null | head -1 || true)"
  if [[ -z "$desc" ]]; then
    printf '%s' "$cask"
  else
    printf '%s — %s' "$cask" "$desc"
  fi
}

log "profile: $DOTFILES_PROFILE"

ALL_CASKS=()
while IFS= read -r line; do
  [[ -n "$line" ]] && ALL_CASKS+=("$line")
done < <(_collect_casks "$DOTFILES_PROFILE")
((${#ALL_CASKS[@]})) || die "no casks found for profile groups"

DEFAULT_ON=()
while IFS= read -r line; do
  [[ -n "$line" ]] && DEFAULT_ON+=("$line")
done < <(manifest_brew_default_on "$DOTFILES_PROFILE")

LABELS=()
PRESELECTED=()
for c in "${ALL_CASKS[@]}"; do
  label="$(_build_label "$c")"
  LABELS+=("$label")
  if ((${#DEFAULT_ON[@]} > 0)); then
    for d in "${DEFAULT_ON[@]}"; do
      if [[ "$c" == "$d" ]]; then
        PRESELECTED+=("$label")
        break
      fi
    done
  fi
done

GUM_ARGS=(choose --no-limit --header "Select casks to install (Space toggle, Enter confirm)")
if ((${#PRESELECTED[@]} > 0)); then
  for sel in "${PRESELECTED[@]}"; do
    GUM_ARGS+=(--selected "$sel")
  done
fi

PICKED=()
while IFS= read -r line; do
  [[ -n "$line" ]] && PICKED+=("$line")
done < <(printf '%s\n' "${LABELS[@]}" | gum "${GUM_ARGS[@]}")

if ((${#PICKED[@]} == 0)); then
  warn "no casks selected; skipping brew bundle"
  exit 0
fi

: >"$OUT"
for line in "${PICKED[@]}"; do
  cask="${line%% — *}"
  printf 'cask "%s"\n' "$cask" >>"$OUT"
done

log "installing ${#PICKED[@]} cask(s) from $OUT"
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --file="$OUT"

SAVE="$HOME/.config/dotfiles/brew-selections.toml"
mkdir -p "$(dirname "$SAVE")"
{
  echo "# Last brew questionnaire — gitignored"
  echo "profile = \"$DOTFILES_PROFILE\""
  echo "generated_at = \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\""
  echo "casks = ["
  for line in "${PICKED[@]}"; do
    cask="${line%% — *}"
    printf '  "%s",\n' "$cask"
  done
  echo "]"
} >"$SAVE"
log "saved selections to $SAVE"
