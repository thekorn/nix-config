# fuzzy finder for aliases
aha() {
  local selected=$(alias | sort | fzf -q "$*")
  if [ ! -z "$selected" ]; then
    local cmd=$(awk -F'=' '{gsub(/\x27/, "", $2); print $2 }' <<<"$selected")
    eval "${cmd}"
  fi
}

# wttr.in
# https://github.com/chubin/wttr.in
wttr() {
  curl wttr.in/"${1:-}"
}

# static file server
sf() {
  open http://localhost:"${1:-9000}"
  python3 -m http.server "${1:-9000}"
}

#git opencommit
ocm() {
  if [ -x "$(command -v op)" ] && [ -x "$(command -v opencommit)" ]; then
    branchPath=$(git symbolic-ref -q HEAD) #Somthing like refs/heads/myBranchName
    branchName=${branchPath##*/}           #Get text behind the last / of the branch path
    regex="([A-Z]+-[0-9]*)"
    prefix=""

    if [[ $branchName =~ $regex ]]; then
      prefix="${match[1]} "
    fi

    op run --env-file="$HOME/.config/opencommit.env" -- opencommit #"${prefix}\$msg"
  else
    git commit "$@"
  fi
}

# flutter
function flutter-watch() {
  local PID_FILE="/tmp/tf$$.pid"
  TMUX='' tmux new-session \; send-keys "flutter run --pid-file=$PID_FILE" Enter \; split-window -v \; send-keys "npx -y nodemon -e dart -x \"cat $PID_FILE | xargs kill -s USR1\"" Enter \; resize-pane -y 5 -t 1 \; select-pane -t 0 \;
  rm $PID_FILE
}

function updateNvim() (
  local CONFIG_DIR=~/.config/nvim
  [ -d "$CONFIG_DIR/.git" ] || git clone -b master git@github.com:thekorn/config.nvim.git $CONFIG_DIR
  cd $CONFIG_DIR
  git checkout master
  git pull
)

function updateZedConfig() (
  local CONFIG_DIR=~/.config/zed
  [ -d "$CONFIG_DIR/.git" ] || git clone -b main git@github.com:thekorn/zed-config.git $CONFIG_DIR
  cd $CONFIG_DIR
  git checkout main
  git pull
)

# nix
function nixswitch() {
  darwin-rebuild switch --flake ~/.config/nix/.#
}

# update config
function update() (
  set -e
  cd ~/.config/nix
  git pull
  nix flake update --commit-lock-file
  git pu
  nixswitch
  updateBrew
  updateNvim
  updateZedConfig
)

# update config
function update-nixos() (
  set -e
  cd ~/.config/nix
  git pull
  nix flake update --commit-lock-file
  git pu
  sudo nixos-rebuild switch --flake ~/.config/nix/.#
  updateNvim
)

function updateBrew() (
  set -e
  brew update
  brew upgrade --greedy
)


function bunte-aws-mfa () {
  secret="aws - burda-studios"

  op item get "$secret" 2>&1 > /dev/null
  if [[ "$?" == "1" ]] ; then
    eval $(op signin)
  fi
  device=$(op item get "$secret" --field device)
  otp=$(op item get "$secret" --otp)
  rush cli --awsmfa --awsmfa-account "$device" --awsmfa-otp "$otp"
}

function ph() {
  set -e
  LC_ALL=C.UTF-8 ssh rpi5-thekorn "pihole $@"
}

fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

function zfif() {
    set -e
    zed $(fif "$@")
}

function cfif() {
    set -e
    code $(fif "$@")
}
