# dotfiles

Manifest-driven macOS (and Linux) dotfiles using **GNU Stow**, per-module **Brewfiles**, and a **gum** cask questionnaire.

## Quick start

```bash
git clone <your-repo> ~/dotfiles && cd ~/dotfiles

# Work Mac
make bootstrap-work
# or
DOTFILES_PROFILE=work.mac ./scripts/bootstrap.sh

# Personal Mac
make bootstrap-personal
```

Requires: `stow`, `brew`, `gum` (`brew install stow gum`).

## Profiles

| Profile | Manifest | Purpose |
|---------|----------|---------|
| `work.mac` | `profiles/work.mac/manifest.toml` | WM, bar, nvim, iterm colors, zsh (OMZ+p10k only); conservative brew groups |
| `personal.mac` | `profiles/personal.mac/manifest.toml` | Same modules; more brew groups; spotify bar widget on by default |

Set `DOTFILES_PROFILE` or use `make bootstrap-work` / `bootstrap-personal`.

## Layout

```
profiles/<name>/manifest.toml   # what to enable
modules/<name>/home/            # stow tree (→ $HOME)
modules/<name>/Brewfile         # optional brew deps
brew/groups/<group>.txt         # cask lists for questionnaire
scripts/bootstrap.sh            # apply profile
scripts/stow-module.sh          # stow one module
scripts/sketchybar-switch.sh    # pick felix / neuton / oxgr
scripts/brew-questionnaire.sh   # gum multi-select casks
```

## Modules (v1)

| Module | Stows | Brew |
|--------|-------|------|
| `aerospace` | `~/.config/aerospace/` | aerospace cask |
| *(bootstrap)* | `scripts/hot-corners/` runs Dock defaults (not a stow module) | — |
| `nvim` | `~/.config/nvim/` | — |
| `iterm2` | `~/.config/iterm2/colors/` | — |
| `zsh` | `~/.oh-my-zsh`, `~/.p10k.zsh` | — |
| `sketchybar-{felix,neuton,oxgr}` | `~/.config/sketchybar/` | via `sketchybar-common` |

**Not in manifests (yet):** `kitty` (broken — fix before enabling), Raycast, Zed.

**Never in repo or manifests:** `gh` hosts, GitHub Copilot, Raycast tokens/secrets.

**Never stowed:** `~/.zshrc` (stays machine-local).

## Sketchybar

Three variants under `modules/sketchybar-*/home/.config/sketchybar/` (only one active at a time):

- `sketchybar-felix`
- `sketchybar-neuton` (layouts: `laptop`, `desktop`, `default`)
- `sketchybar-oxgr`

Switch:

```bash
./scripts/sketchybar-switch.sh --from-manifest
./scripts/sketchybar-switch.sh --variant felix --spotify off
./scripts/sketchybar-switch.sh --variant neuton --layout desktop --spotify on --save
```

**Spotify widget** is controlled only by manifest `sketchybar.features.spotify_widget` or `--spotify on|off` — nothing is hardcoded per profile in shell logic.

- **Neuton:** `modules/sketchybar-neuton/features/` assembles `sketchybarrc` from base + optional fragment.
- **Felix:** omits `source "$ITEM_DIR/spotify.sh"` and installs a no-op `items/spotify.sh` when off.
- **Oxgr:** no spotify items.

## Brew questionnaire

Manifest `brew.groups` lists which `brew/groups/*.txt` files appear in the picker.  
If a cask is not in any group for your profile, it **never appears** (not blocked — invisible).

```bash
DOTFILES_PROFILE=work.mac ./scripts/brew-questionnaire.sh
# or
make brew-pick
```

Writes a temp Brewfile and runs `brew bundle install`. Saves last choices to `~/.config/dotfiles/brew-selections.toml` (gitignored).

## Local overrides

`~/.config/dotfiles/local.toml` — optional, gitignored. Created with `sketchybar-switch.sh --save`.

## Linux

`only-linux/` remains for Hyprland/Fedora; same manifest pattern can be extended later.

## Tentative (do not bootstrap yet)

- **Kitty** — fix config drift, then add `"kitty"` to manifests.
- **Raycast** — sanitized exports only.
- **Zed** — partial `settings.json` + extension picker (like brew groups).
