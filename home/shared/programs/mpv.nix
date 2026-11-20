{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.mpv;
  # mpv needs swift on darwin, which fails to build there, so it comes from
  # homebrew (hosts/darwin/shared/homebrew.common.nix).
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  mpv =
    if isDarwin
    then "mpv"
    else "${pkgs.mpv-unwrapped}/bin/mpv";
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

    ${mpv} "$selected"
  '';
in {
  options.custom.mpv.enable = lib.mkEnableOption "mpv";
  config.home.packages = lib.mkIf cfg.enable (
    lib.optional (!isDarwin) pkgs.mpv-unwrapped
    ++ [
      # 2026-02-23: broken build
      #pkgs.yt-dlp
      play
    ]
  );
}
