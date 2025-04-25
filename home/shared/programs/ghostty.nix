{pkgs, ...}: {
  # package still needs to be installed via https://github.com/ghostty-org/ghostty
  home.file = {".config/ghostty/config".source = ./dotfiles/ghostty/config;};
  programs.zsh = {
    #localVariables = {
    #  GHOSTTY_RESOURCES_DIR = "/Applications/Ghostty.app/Contents/Resources/ghostty";
    #};
    #initContent= ''
    #  if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
    #    autoload -Uz -- "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
    #    ghostty-integration
    #    unfunction ghostty-integration
    #  fi
    #'';

    shellAliases = {
      ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";
    };
  };
}
