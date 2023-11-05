# sudo dnf install ninja-build cmake meson gcc-c++ libxcb-devel libX11-devel pixman-devel wayland-protocols-devel cairo-devel pango-devel
# sudo dnf install 'pkgconfig(wayland-server)' libdrm-devel libxkbcommon-devel mesa-libEGL-devel mesa-libgbm-devel libinput-devel libudev-devel hwdata-devel

# install wayland-protocols from source cause version numbers funny
# git clone https://gitlab.freedesktop.org/wayland/wayland-protocols
# cd wayland-protocols
# meson build/
# ninja -C build/ install
# cd ..
# sudo rm -rf wayland-protocols
# 
# git clone --recursive https://github.com/hyprwm/Hyprland ~/dotfiles/Hyprland-build-files # separates from dotfiles git repo
# cd ~/dotfiles/Hyprland-build-files
# meson _build
# ninja -C _build
# sudo ninja -C _build install
# sudo cp /usr/local/share/wayland-sessions/hyprland.desktop /usr/share/wayland-sessions
# sudo ln -s ~/dotfiles/Hyprland ~/.config/hypr
# cp example/hyprland.conf ~/.config/hypr
# sudo rm -rf ~/dotfiles/Hyprland-build-files
#
sudo dnf copr enable solopasha/hyprland
sudo dnf install hyprland --allowerasing
sudo ln -s ~/dotfiles/Hyprland ~/.config/hypr
