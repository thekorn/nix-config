

function updateNvim() (
  local CONFIG_DIR=~/.config/nvim
  [ -d "$CONFIG_DIR/.git" ] || git clone -b main git@github.com:thekorn/config.nvim.git $CONFIG_DIR
  cd $CONFIG_DIR
  git checkout main
  git pull
)


# update config
function update() (
  set -e
  cd ~/.config/nix
  git pull
  nix flake update --commit-lock-file
  git pu
  sudo nixos-rebuild switch --flake ~/.config/nix/.#
  updateNvim
)
