{pkgs, ...}: let
  nodePackages = ["@microsoft/rush@5.166.0" "pnpm@10.27.0" "pm2"];
  nodeTools = pkgs.writeText "ctf-node-tools" (builtins.toJSON nodePackages);
in {
  packages = with pkgs; [fnm mongosh docker-client nodejs awscli2 mkcert mongodb-tools jq];

  env.DEVENV_TOOLBOX = "CTF";

  enterShell = ''
    export CTF_NODE_TOOLS="$DEVENV_ROOT/node-tools"
    if ! cmp -s ${nodeTools} "$CTF_NODE_TOOLS/.installed" \
      || [ ! -x "$CTF_NODE_TOOLS/node_modules/.bin/rush" ] \
      || [ ! -x "$CTF_NODE_TOOLS/node_modules/.bin/pnpm" ] \
      || [ ! -x "$CTF_NODE_TOOLS/node_modules/.bin/pm2" ]; then
      ${pkgs.nodejs}/bin/npm install --prefix "$CTF_NODE_TOOLS" --no-save --package-lock=false \
        ${pkgs.lib.escapeShellArgs nodePackages} || exit 1
      cp ${nodeTools} "$CTF_NODE_TOOLS/.installed"
    fi
    eval "$(fnm env --shell bash)"
    export PATH="$CTF_NODE_TOOLS/node_modules/.bin:$PATH"
  '';
}
