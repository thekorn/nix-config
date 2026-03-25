{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
    settings = {
      theme = "nord";
      font-family = "GeistMono Nerd Font";
      font-size = 12;
      font-thicken = true;
      confirm-close-surface = false;
      auto-update = "off";
      copy-on-select = "clipboard";
      quit-after-last-window-closed = true;
      cursor-style-blink = true;
      shell-integration-features = "no-cursor, sudo, title";
      config-file = "?custom";
    };
  };
}
