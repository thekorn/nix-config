{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.mpv;
  play = pkgs.writeShellScriptBin "play-ls" ''
    set -e

    if [[ $# -eq 1 ]]; then
        path=$1
    else
        path=.
    fi

    selected=$(${pkgs.fd}/bin/fd --base-directory $path -tf -X file --mime-type| egrep 'image|video'| cut -f1 -d : |${pkgs.fzf}/bin/fzf)
    if [[ -z $selected ]]; then
        echo "No file selected"
        exit 0
    fi

    ${pkgs.mpv-unwrapped}/bin/mpv "$selected"
  '';
in {
  options.custom.mpv.enable = lib.mkEnableOption "mpv";
  config.home.packages = lib.mkIf cfg.enable [
    pkgs.mpv-unwrapped
    # 2026-02-23: broken build
    #pkgs.yt-dlp
    play
  ];
}
