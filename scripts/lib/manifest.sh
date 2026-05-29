#!/usr/bin/env bash
# Minimal TOML reader for dotfiles manifests (no external deps).

# shellcheck source=scripts/lib/common.sh
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

manifest_path() {
  local profile="${1:-${DOTFILES_PROFILE:-work.mac}}"
  local path="$DOTFILES_ROOT/profiles/$profile/manifest.toml"
  [[ -f "$path" ]] || die "manifest not found: $path"
  printf '%s' "$path"
}

# manifest_get <key> [profile]
# Keys use dot notation, e.g. sketchybar.variant
manifest_get() {
  local key="$1"
  local profile="${2:-${DOTFILES_PROFILE:-work.mac}}"
  local file
  file="$(manifest_path "$profile")"

  case "$key" in
    profile.id)
      _manifest_scalar "$file" '^id = ' "profile"
      ;;
    sketchybar.variant)
      _manifest_scalar "$file" '^variant = ' "sketchybar"
      ;;
    sketchybar.neuton_layout)
      _manifest_scalar "$file" '^neuton_layout = ' "sketchybar"
      ;;
    sketchybar.features.spotify_widget)
      _manifest_bool "$file" '^spotify_widget = ' "sketchybar.features"
      ;;
    brew.questionnaire.interactive)
      _manifest_bool "$file" '^interactive = ' "brew.questionnaire" && return 0
      return 1
      ;;
    brew.questionnaire.ui)
      _manifest_scalar "$file" '^ui = ' "brew.questionnaire"
      ;;
    *)
      die "unknown manifest key: $key"
      ;;
  esac
}

_manifest_scalar() {
  local file="$1" pattern="$2" section="${3:-}"
  local line=""
  if [[ -n "$section" ]]; then
    line="$(awk -v sec="$section" -v pat="$pattern" '
      $0 == "[" sec "]" { insec=1; next }
      /^\[/ { insec=0 }
      insec && $0 ~ pat { print; exit }
    ' "$file")"
  else
    line="$(grep -E "$pattern" "$file" | head -1 || true)"
  fi
  line="${line#*=}"
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  line="${line#\"}"
  line="${line%\"}"
  printf '%s' "$line"
}

_manifest_bool() {
  local val
  val="$(_manifest_scalar "$@")"
  [[ "$val" == "true" ]]
}

# manifest_modules <profile> — prints one module name per line
manifest_modules() {
  local profile="${1:-${DOTFILES_PROFILE:-work.mac}}"
  local file
  file="$(manifest_path "$profile")"
  awk '
    /^\[modules\]/ { in_mod=1; in_list=0; next }
    /^\[/ { in_mod=0; in_list=0 }
    in_mod && /^enable = \[/ { in_list=1; next }
    in_list && /\]/ { exit }
    in_list {
      gsub(/[^a-zA-Z0-9_-]/, "", $0)
      if (length($0) > 0) print $0
    }
  ' "$file"
}

# manifest_brew_groups <profile>
manifest_brew_groups() {
  local profile="${1:-${DOTFILES_PROFILE:-work.mac}}"
  local file
  file="$(manifest_path "$profile")"
  awk '
    /^\[brew\]/ { in_brew=1; in_groups=0; next }
    /^\[/ { in_brew=0; in_groups=0 }
    in_brew && /^groups = \[/ { in_groups=1; next }
    in_groups && /\]/ { exit }
    in_groups {
      gsub(/[^a-zA-Z0-9_-]/, "", $0)
      if (length($0) > 0) print $0
    }
  ' "$file"
}

# manifest_brew_default_on <profile>
manifest_brew_default_on() {
  local profile="${1:-${DOTFILES_PROFILE:-work.mac}}"
  local file
  file="$(manifest_path "$profile")"
  awk '
    /^\[brew\]/ { in_brew=1; in_list=0; next }
    /^\[/ { in_brew=0; in_list=0 }
    in_brew && /^default_on = \[/ {
      if (match($0, /\[[[:space:]]*\]/)) { exit }
      in_list=1
      next
    }
    in_list && /\]/ { exit }
    in_list {
      rest = $0
      while (match(rest, /"[^"]+"/)) {
        print substr(rest, RSTART + 1, RLENGTH - 2)
        rest = substr(rest, RSTART + RLENGTH)
      }
    }
  ' "$file"
}
