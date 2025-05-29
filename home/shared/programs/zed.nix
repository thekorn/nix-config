{pkgs, ...}: let
  todo = pkgs.writeShellScriptBin "todo" ''
    set -e

    if [ -x "$(command -v zed)" ]; then
        selected=$(
            ${pkgs.ripgrep}/bin/rg --line-number --no-heading --color=always --smart-case "(TODO|FIXME|HACK)" \
                | ${pkgs.fzf}/bin/fzf -d ':' -n 2.. --ansi --no-sort --preview '${pkgs.bat}/bin/bat --style=numbers --color=always --highlight-line {2} {1}'
        )

        if [[ -z $selected ]]; then
            exit 0
        fi

        # Extract Path
        path=$(echo "$selected" | cut -d':' -f1)

        # Extract Position
        position=$(echo "$selected" | cut -d':' -f2)


        echo "Opening file: $path:$position ..."
        # this requires the shell integration to be installed
        zed "$path:$position"
    fi
  '';
in {
  home.packages = [todo pkgs.zed-editor];
  # config is now manged in https://github.com/thekorn/zed-config
  #home.file = {
  #  ".config/zed/settings.json".source = ./dotfiles/zed/settings.json;
  #  ".config/zed/themes/nord.json".source = ./dotfiles/zed/nord.json;
  #};
  programs.zsh = {
    shellAliases = {
      zed = "zeditor";
    };
  };
}
