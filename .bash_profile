### General

#---
## Generate a gitignore file. Comma separated values.
#---
function gi {
	curl -sL https://www.gitignore.io/api/$@ > .gitignore
}

#---
## Change directory and list contents of new working directory
#---
function cl {
	cd $1
	ls
}

#---
## Notify aloud that the previous command is complete
#---
function notify {
	"$@"
	# todo: figure out how to display $@
	osascript -e 'display notification "'"$1"' '"$2"'" with title "Command complete"'
}

### Docker

alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcub="docker-compose up -d --build"
alias dcd="docker-compose down"
alias dcb="docker-compose build"

#---
## Delete all docker containers that have a status of exited.
#---
function docker-cleanup {
	docker rm $(docker ps --all --quiet --filter status=exited)
}

### Homebrew

export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

# https://github.com/Homebrew/brew/issues/3784#issuecomment-364675767
alias brew-nuke="rm -rf $(brew --cache)"

alias brew-scrub="brew cleanup -s"

#---
## Runs Homebrew update, upgrade, cask upgrade, cleanup, and doctor
#---
function brewup {
	function _print {
		local CYAN=6
		echo "\n$(tput bold)$(tput setaf $CYAN)$1$(tput sgr0)"
	}
	_print "brew update"
	brew update
	_print "brew upgrade"
	brew upgrade
	_print "brew cask upgrade"
	brew cask upgrade
	_print "brew cleanup -s"
	brew cleanup -s
 	_print "brew doctor"
	brew doctor
}

### Java

eval "$(jenv init -)"

#export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-11.0.2.jdk/Contents/Home"
#export PATH="/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"

### Scala

export SCALA_HOME="/usr/local/opt/scala/idea"

### Ammonite REPL

alias amm="amm --no-remote-logging"

### Node

export NVM_SYMLINK_CURRENT=true
export NVM_DIR="$HOME/.nvm"

## see: https://medium.com/@danielzen/using-nvm-with-webstorm-or-other-ide-d7d374a84eb1
# [ -s “$NVM_DIR/nvm.sh” ] && \. “$NVM_DIR/nvm.sh” # This loads nvm

#---
## Delete all node_modules folders in workspace
#---
function delete-node-modules {
	find ~/Workspace -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;
	find ~/Workspace2 -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;
}

#---
## Replaces latest node, keeping installed global packages
#---
function nvm-upgrade {
	CURR=$(nvm current)
	nvm install node --reinstall-packages-from=node
	nvm uninstall $CURR
}

#---
## Bootstraps a Node.js project in the current directory
#---
function node-project {
	NAME=$1

	## dir
	mkdir $NAME
	cd $NAME

	## readme
	echo "# $NAME\n" > README.md

	## license
	npx license gpl3 -o "$(npm get init.author.name)" > LICENSE
	# npx license $(npm get init.license) -o "$(npm get init.author.name)" > LICENSE

	## gitignore
	gi node,visualstudiocode,webstorm,linux,macos,windows
	# npx gitignore node

	## code of conduct
	npx covgen "$(npm get init.author.email)"

	## npm
	npm init -y
	sort-package-json
	yarn

	## git
	git init
	git add -A
	git commit -m "Initial commit"
}

### SQLite

export PATH="/usr/local/opt/sqlite/bin:$PATH"

### Rust

export PATH="$HOME/.cargo/bin:$PATH"

### Dunno?

export GPG_TTY=$(tty)

### sdkman

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# ^ Uh-huh, sure.
export SDKMAN_DIR="/Users/martin/.sdkman"
[[ -s "/Users/martin/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/martin/.sdkman/bin/sdkman-init.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
