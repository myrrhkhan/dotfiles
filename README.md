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
| `work.mac` | `profiles/work.mac/manifest.toml` | WM, bar, nvim, kitty, cava, iterm colors, zsh; conservative brew groups |
| `personal.mac` | `profiles/personal.mac/manifest.toml` | Same modules; more brew groups; Spotify bar widget on |

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
| `kitty` | `~/.config/kitty/` | kitty cask |
| `cava` | `~/.config/cava/` | cava formula |
| `sketchybar-{felix,neuton,oxgr}` | `~/.config/sketchybar/` | via `sketchybar-common` |

Wallpapers live at `~/dotfiles/Wallpapers/` (not stowed). Kitty uses `${HOME}/dotfiles/Wallpapers/kitty_background.png`.

**Not in manifests (yet):** Raycast, Zed.

**Never in repo or manifests:** `gh` hosts, GitHub Copilot, Raycast tokens/secrets.

**Never stowed:** `~/.zshrc` (stays machine-local).

## Sketchybar

**Default bar (bootstrap):** neuton + **laptop** layout on every profile — transparent bar, weather, battery, volume.

**Spotify widget** (profile only):

| Profile | `spotify_widget` |
|---------|------------------|
| `work.mac` | `false` |
| `personal.mac` | `true` |

Requires the Spotify app installed locally (not a Homebrew cask in this repo). The widget is omitted from `sketchybarrc` when off.

```bash
./scripts/sketchybar-switch.sh --from-manifest
make sketchybar   # uses DOTFILES_PROFILE
```

**Experiments** (CLI overrides): `--variant felix|oxgr`, `--layout desktop`, `--spotify on|off`.

Alternate variants live under `modules/sketchybar-*/`; only one is stowed at a time.

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

## First-time kitty on a machine

If `~/.config/kitty` is an old copied directory (not stow symlinks), remove it before bootstrap:

```bash
rm -rf ~/.config/kitty
make bootstrap-work   # or bootstrap-personal
```

## Tentative (do not bootstrap yet)

- **Raycast** — sanitized exports only.
- **Zed** — partial `settings.json` + extension picker (like brew groups).
