{pkgs, ...}: {
  home.packages = with pkgs; [ghostty-bin];
  home.file = {".config/ghostty/config".source = ./dotfiles/ghostty/config;};
  programs.zsh = {
    localVariables = {
      GHOSTTY_RESOURCES_DIR = "${pkgs.ghostty-bin}/Applications/Ghostty.app/Contents/Resources/ghostty";
    };
    initContent = ''
      if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
        autoload -Uz -- "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
        #ghostty-integration
        #unfunction ghostty-integration
      fi
    '';

    shellAliases = {
      ghostty = "${pkgs.ghostty-bin}/Applications/Ghostty.app/Contents/MacOS/ghostty";
    };
  };
}
