macos-install:
	xargs brew install < ./deps.txt
	xargs brew install < ./deps-macos.txt
fedora-install:
	sudo dnf install $(cat deps.txt)

links:
	ln -s ~/dotfiles/nvim ~/.config/nvim
