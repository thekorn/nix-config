{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.workmux;
in {
  options.custom.workmux = {
    enable = lib.mkEnableOption "Workmux";
    defaultAgent = lib.mkOption {
      type = lib.types.str;
      default = "amp";
      description = "Default agent for Workmux";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.llm-agents.workmux
      {
        amp = pkgs.llm-agents.amp;
        cursor-agent = pkgs.llm-agents.cursor-agent;
      }."${cfg.defaultAgent}"
    ];
    # broken build, failing tests
    #config.home.packages = [inputs.workmux.packages.${pkgs.system}.default];

    xdg.configFile."workmux/config.yaml".text = ''
      nerdfont: true
      worktree_dir: ~/.local/share/workmux/{project}
      agent: ${cfg.defaultAgent}
      panes:
        - command: <agent>
          focus: true
        - split: vertical
          size: 15
    '';

    xdg.configFile."amp/plugins/workmux-status.ts" = lib.mkIf (cfg.defaultAgent == "amp") {
      source = ./dotfiles/amp/plugins/workmux-status.ts;
    };
  };
}
