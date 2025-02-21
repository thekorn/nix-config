{pkgs, ...}: let
  api = pkgs.writeShellScriptBin "api" ''
    BASEDIR=~/devel/github.com/thekorn/api-collection/

    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(${pkgs.fd}/bin/fd -p -t d -d 3 --min-depth 2 . "$BASEDIR" | sed "s;$BASEDIR;;" | ${pkgs.fzf}/bin/fzf)
        if [[ -z $selected ]]; then
            echo "No directory selected"
            exit 0
        fi
        selected="$BASEDIR$selected"
    fi

    if [ ! -d "$selected" ]; then
      echo "$selected does not exist."
      exit 1
    fi

    if [ ! -f "$selected/slumber.yml" ]; then
      echo "$selected is not a slumber directory."
      exit 1
    fi

    if [ -f "$selected/.env" ]; then
      ${pkgs._1password-cli}/bin/op run --env-file="$selected/.env" -- ${pkgs.slumber}/bin/slumber --file "$selected/slumber.yml"
    else
      ${pkgs.slumber}/bin/slumber --file "$selected/slumber.yml"
    fi
  '';
in {
  home.packages = [
    pkgs.slumber
    api
  ];
}
