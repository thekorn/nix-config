{
  pkgs,
  config,
  ...
}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidget.command = "";
  };
}
