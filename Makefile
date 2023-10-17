bashrc-install:
	@echo "installing bashrc"
	cd bashrc && ./install.sh

bashrc-uninstall:
	@echo "ininstalling bashrc"
	cd bashrc && ./uninstall.sh

gitconfig-install:
	@echo "installing gitconfig"
	cp gitconfig ~/.gitconfig
	cp gitignore ~/.gitignore

gitconfig-uninstall:
	@echo "installing gitconfig"
	rm ~/.gitconfig
	rm ~/.gitignore
