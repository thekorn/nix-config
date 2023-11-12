# fuzzy finder for aliases
aha() {
  local selected=$(alias | sort | fzf -q "$*")
  if [ ! -z "$selected" ]; then
    local cmd=$(awk -F'=' '{gsub(/\x27/, "", $2); print $2 }' <<< "$selected")
    eval ${=cmd}
  fi
}

# wttr.in
# https://github.com/chubin/wttr.in
wttr() {
    curl wttr.in/"${1:-}";
}

# static file server
sf() {
    open http://localhost:"${1:-9000}";
    python3 -m http.server "${1:-9000}";
}

#git opencommit
cm() {
  if [ -x "$(command -v op)" ] && [ -x "$(command -v opencommit)" ]; then
    op run --env-file="$HOME/.config/opencommit.env" -- opencommit
  else
    git commit "$@"
  fi
}

# flutter
function flutter-watch(){
  local PID_FILE="/tmp/tf$$.pid"
  TMUX='' tmux new-session \;\
    send-keys "flutter run --pid-file=$PID_FILE" Enter \;\
    split-window -v \;\
    send-keys "npx -y nodemon -e dart -x \"cat $PID_FILE | xargs kill -s USR1\"" Enter \;\
    resize-pane -y 5 -t 1 \;\
    select-pane -t 0 \;
  rm $PID_FILE;
}

function updateNvim() (
  local CONFIG_DIR=~/.config/nvim;
  [ -d "$CONFIG_DIR/.git" ] || git clone -b main git@github.com:thekorn/config.nvim.git $CONFIG_DIR;
  cd $CONFIG_DIR;
  git pull;
)

# nix
function nixswitch(){
  darwin-rebuild switch --flake ~/.config/nix/.#;
}

# update config
function update()(
  set -e
  cd ~/.config/nix;
  git pull;
  nix flake update;
  nixswitch;
  updateBrew;
  updateNvim;
)

# update config
function update-nixos()(
  set -e
  cd ~/.config/nix;
  git pull;
  sudo nixos-rebuild switch --flake ~/.config/nix/.#;
  updateNvim;
)

function updateBrew()(
  set -e
  brew update;
  brew upgrade;
)