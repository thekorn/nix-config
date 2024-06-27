{pkgs, ...}: {
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nano";
    # we need that for vulkan...
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/local/share";
  };

  home.sessionPath = [
    "$HOME/.pub-cache/bin"

    "$HOME/.local/bin"
  ];
}
