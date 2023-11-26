bashrc-install:
	@echo "installing bashrc"
	bashrc/install.sh

bashrc-uninstall:
	@echo "unininstalling bashrc"
	bashrc/uninstall.sh

gitconfig-install:
	@echo "installing gitconfig"
	cp misc/git/gitconfig ~/.gitconfig
	cp misc/git/gitignore ~/.gitignore

gitconfig-uninstall:
	@echo "uninstalling gitconfig"
	rm ~/.gitconfig
	rm ~/.gitignore

vimrc-install:
	@echo "installing vimrc"
	cp misc/vimrc ~/.vimrc

vimrc-uninstall:
	@echo "uninstalling vimrc"
	rm ~/.vimrc

starship-install:
	@echo "installing starship"
	cp misc/starship.toml ~/.config/starship.toml

starship-uninstall:
	@echo "uninstalling starship"
	rm ~/.config/starship.toml

ls-install:
	@echo "installing ls"
	cp script/ls.sh ~/bin/ls.sh

ls-uninstall:
	@echo "uninstalling ls"
	rm ~/bin/ls.sh