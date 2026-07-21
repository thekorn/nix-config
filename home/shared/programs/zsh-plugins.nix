{lib, config, ...}: let
  pluginDir = ./dotfiles/zsh-plugins;
  vendoredPlugins = [
    "${pluginDir}/jira-plus.plugin.zsh"
    "${pluginDir}/gitgo.plugin.zsh"
    "${pluginDir}/zsh-dot-up.plugin.zsh"
    "${pluginDir}/tmux-sessionizer.zsh"
  ];
  zplugPlugins = [
    {name = "gerges-zz/oh-my-zsh-jira-plus";}
    {name = "ltj/gitgo";}
    {name = "toku-sa-n/zsh-dot-up";}
    {name = "thekorn/tmux-sessionizer";}
  ];
in {
  imports = [
    ({lib, ...}: {
      options.custom.zsh.pluginBackend = lib.mkOption {
        type = lib.types.enum [
          "zplug"
          "zplug-vendor"
        ];
        default = "zplug";
        description = ''
          How zsh plugins are loaded.

          - `zplug`: install and load plugins via zplug on shell startup
          - `zplug-vendor`: source vendored plugin files directly (faster startup)
        '';
      };
    })
  ];

  config = {
    programs.zsh = {
      zplug = lib.mkIf (config.custom.zsh.pluginBackend == "zplug") {
        enable = true;
        plugins = zplugPlugins;
      };

      initContent = lib.mkIf (config.custom.zsh.pluginBackend == "zplug-vendor") (lib.mkBefore (
        lib.concatMapStringsSep "\n" (path: "source ${path}") vendoredPlugins
      ));
    };
  };
}
