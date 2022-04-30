#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# SOURCES
## Display package unknown command is from
## Update db with "sudo pkgfile -u"
source /usr/share/doc/pkgfile/command-not-found.bash

## Add __git_ps1 to show git branch
source $HOME/.config/bash/git-prompt.sh

## Use icons from: https://github.com/sebastiencs/icons-in-terminal
#source /usr/share/icons-in-terminal/icons_bash.sh

## Bash completion for aliases (https://github.com/cykerway/complete-alias)
source ~/.bash_completion.d/complete_alias

## McFly pkg configuration
source /usr/share/doc/mcfly/mcfly.bash

# ALIASES
alias ls='ls --color=auto'
alias diff='diff --color=auto'
alias dobu='sudo screen -dmS "backup" "/media/backups/perform-backup.sh"'
#alias eb='$EDITOR $HOME/.bashrc && source $HOME/.bashrc'
alias eb='touch $HOME/.bashrc.md5 ; $EDITOR $HOME/.bashrc && [ "$(cat $HOME/.bashrc.md5)" = "$(md5sum $HOME/.bashrc)" ] || source $HOME/.bashrc && md5sum $HOME/.bashrc > $HOME/.bashrc.md5'
alias ebc='$GUI_EDITOR $HOME/.bashrc && source $HOME/.bashrc'
#alias rmdp='yay -Qdtq | yay -Rns - || echo No dependencies to remove!'
alias rmdp='yay --clean'
alias e='swaymsg exec '
alias sysup='snapper create --command "yay --repo -Syyu --noconfirm" -d "System upgrade (repo)" -c timeline'
alias sysup-aur='snapper create --command "yay --aur -Syyu --noconfirm" -d "System upgrade (aur)" -c timeline'
alias sysup-shutdown='sysup && shutdown now'
alias snapc='snapper create -t single -c timeline -d'
alias lsblk='lsblk -o NAME,MAJ:MIN,RM,FSTYPE,LABEL,SIZE,FSAVAIL,RO,MOUNTPOINT,UUID'
alias mpv='mpv --hr-seek=yes'
alias cat='bat'
alias du='dust'
alias df='duf'
alias find='fd'
alias dig='echo -e "Other cmd: dog\n" && dig'
alias cp='cpg --progress'
alias mv='mvg --progress'
alias vim='lvim'

alias i='yay -Sy '
alias ir='yay -R '
alias ird='yay -Rns '
alias ll='$HOME/.userscripts/lsnano.sh'
alias sc='$EDITOR $HOME/.config/sway/config.d/'
alias scc='$GUI_EDITOR $HOME/.config/sway/'
alias ev='$EDITOR $HOME/.config/lvim/config.lua'
alias sound='alsamixer --card=2'
alias ssh='TERM=xterm-256color ssh'
alias sshc='$EDITOR $HOME/.ssh/config'
alias serve='webfsd -F -p 5050 -r '
alias startvm='$HOME/.config/sway/scripts.d/start-vm.sh'
alias snapcp='$HOME/.config/sway/scripts.d/snapshot-pre-post.sh'
alias winshit='sudo grub-reboot "WinShit" && reboot'
alias dockerstart='sudo systemctl start docker'
alias new-project='curl -sSL https://github.com/Sherex/ts-template/raw/main/create.sh | bash -s '

## Create completions for all aliases
complete -F _complete_alias "${!BASH_ALIASES[@]}"

# FUNCTIONS
snapkeep () {
  snapper create -t single -d "[$2]$1" --read-write --from $2
}

snapfix-sysup () {
  PRE_NUMBER=$1
  if [[ ! $PRE_NUMBER =~ ^[0-9]+$ ]]; then
    echo
    snapper list
    echo
    echo "ERROR: Please specify the PRE_NUMBER as first argument"
    echo "Exiting..."
    return
  fi
  DESC=${2:-"System upgrade (repo)"}

  # Return all snapshot numbers between $PRE_NUMBER and latest as a space delimited string (eg. "255 256 257")
  SNAPSHOTS_TO_REMOVE=$(snapper --jsonout list | jq -r ".root | map(select(.number > $PRE_NUMBER and (.type | match(\"pre|post\"))).number) | join(\" \")")

  echo "Removing these snapshots:"
  snapper list | grep -E "^(?${SNAPSHOTS_TO_REMOVE// /\|})" # Param expansion replace space with |

  read -e -p 'Do you wish to delete these snapshots? (y/N): ' CONTINUE_ANSWER
  if [[ ! ${CONTINUE_ANSWER,,} =~ ^(ye?s?)$ ]]; then
    echo 'Exiting...'
    return
  fi
  
  echo "Removing snapshots: $SNAPSHOTS_TO_REMOVE"
  snapper remove $SNAPSHOTS_TO_REMOVE

  echo -n "Creating post snapshot for $PRE_NUMBER with number "
  snapper create --type post --pre-number $PRE_NUMBER -d "$DESC" --cleanup-algorithm timeline --read-only --print-number
}

lockscreen () {
  LOCK_PATH="/tmp/lockscreen-status.lock"
  if [ "$1" = "disable" ]; then
    echo "Disabling lockscreen"
    echo "disabled" > "$LOCK_PATH"
  elif [ "$1" = "enable" ]; then
    echo "Enabling lockscreen"
    rm $LOCK_PATH
  elif [ "$1" = "status" ]; then
    if [ ! -e "$LOCK_PATH" ]; then
      echo "Lockscreen is enabled"
      return 0
    fi
    echo "Lockscreen is disabled"
    return 2
  fi
}


# EXPORTS
#export PS1="λ \W$(__git_ps1) > "
export PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\h:\[\033[0;35m\]\w\[\033[0;32m\]$(__git_ps1)\n\[\033[0m\033[0;36m\]λ\[\033[0m\033[0;32m\] ▶\[\033[0m\] '
export EDITOR="lvim"
export GUI_EDITOR="code"
export VISUAL="vim"
export BROWSER="firefox"
export TERMINAL="kitty"
export GTK_CSD="0"
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

## Locations
export USERSCRIPTS_CACHE="$HOME/.cache/userscripts"
export PROJECTS_DIRECTORY="$HOME/documents/git-reps"

## Old way for starting firefox in wayland mode
#export GDK_BACKEND="wayland"
## New way
export MOZ_ENABLE_WAYLAND=1
## https://wiki.archlinux.org/title/Firefox#Applications_on_Wayland_can_not_launch_Firefox
export MOZ_DBUS_REMOTE=1

export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export XDG_RUNTIME_DIR=/run/user/1000
export XDG_CONFIG_HOME=$HOME/.config
#export WAYLAND_DISPLAY=wayland-1

export LIBSEAT_BACKEND=logind
export WLR_DRM_NO_MODIFIERS=1

# HW rendered mouse on nouveau disappearing ( https://github.com/swaywm/sway/issues/3617 )
export WLR_NO_HARDWARE_CURSORS=1

## nnn specific
export NNN_PLUG='u:geplugs;d:dragdrop;p:preview-tui-ext'
export USE_VIDEOTHUMB=1
export NNN_FIFO='/tmp/nnn.fifo'

# NVM SPECIFIC
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /usr/share/nvm/init-nvm.sh

# NNN quitcd
nnn_quitcd ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

alias la='nnn_quitcd -re'


source /home/sherex/.config/broot/launcher/bash/br


# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION
