.PHONY: bootstrap bootstrap-work bootstrap-personal stow-% sketchybar brew-pick hot-corners

bootstrap-work:
	DOTFILES_PROFILE=work.mac ./scripts/bootstrap.sh

bootstrap-personal:
	DOTFILES_PROFILE=personal.mac ./scripts/bootstrap.sh

bootstrap:
	./scripts/bootstrap.sh

stow-%:
	./scripts/stow-module.sh -R $*

sketchybar:
	./scripts/sketchybar-switch.sh --from-manifest

brew-pick:
	./scripts/brew-questionnaire.sh

hot-corners:
	./scripts/hot-corners/install.sh
