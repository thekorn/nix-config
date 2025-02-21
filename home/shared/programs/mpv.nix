{pkgs, ...}: let
  play = pkgs.writeShellScriptBin "play-ls" ''
    set -e

    if [[ $# -eq 1 ]]; then
        path=$1
    else
        path=.
    fi

    selected=$(${pkgs.eza}/bin/eza -f $path | xargs file --mime-type| egrep 'image|video'| cut -f1 -d : |${pkgs.fzf}/bin/fzf)
    if [[ -z $selected ]]; then
        echo "No file selected"
        exit 0
    fi

    ${pkgs.mpv-unwrapped}/bin/mpv "$selected"
  '';
in {
  home.packages = [
    pkgs.mpv-unwrapped
    pkgs.yt-dlp
    play
  ];
}
