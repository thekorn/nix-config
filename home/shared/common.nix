{pkgs, ...}: {
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nano";
  };

  home.sessionPath = [
    "$HOME/.pub-cache/bin"

    "$HOME/.local/bin"
  ];
}
