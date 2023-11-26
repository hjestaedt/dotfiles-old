bashrc-install:
	@echo "installing bashrc"
	bashrc/install.sh

bashrc-uninstall:
	@echo "unininstalling bashrc"
	bashrc/uninstall.sh

gitconfig-install:
	@echo "installing gitconfig"
	cp git/gitconfig ~/.gitconfig
	cp git/gitignore ~/.gitignore

gitconfig-uninstall:
	@echo "uninstalling gitconfig"
	rm ~/.gitconfig
	rm ~/.gitignore

vimrc-install:
	@echo "installing vimrc"
	cp vim/vimrc ~/.vimrc

vimrc-uninstall:
	@echo "uninstalling vimrc"
	rm ~/.vimrc