#
# ~/.bash_profile
#

# SSH-agent socket
## Related service: ~/.config/systemd/user/ssh-agent.service
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ ! -f /run/user/1000/wayland-1.lock ]]; then
  mkdir -p ~/.log/sway/

  # Start Sway
  echo
  echo
  echo
  echo "###################### BOOT $(date)" >> ~/.log/sway/sway.log
  sway | awk '{ print strftime("%m-%d-%YT%H:%M:%SZ", systime()), " - ", $0; fflush()}' >> ~/.log/sway/sway.log

  # GPG TTY
  export GPG_TTY=$(tty)
fi

source /home/sherex/.config/broot/launcher/bash/br
