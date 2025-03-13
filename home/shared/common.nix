{pkgs, ...}: {
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nano";
    # we need that for vulkan...
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/local/share";

    # superfile needs xdg config home
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  home.sessionPath = [
    "$HOME/.pub-cache/bin"

    "$HOME/.local/bin"
  ];
}
