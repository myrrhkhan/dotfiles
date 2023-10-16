# https://dev.to/darrinndeal/setting-mac-hot-corners-in-the-terminal-3de

# screensaver
defaults  write com.apple.dock wvous-tl-corner -int 5

# launchpad
defaults write com.apple.dock wvous-bl-corner -int 11

# desktop
defaults write com.apple.dock wvous-br-corner -int 4

# notification center
defaults write com.apple.dock wvous-tr-corner -int 12

killall Dock
