{
  inputs,
  username,
  ...
}: {
  imports = [
    ./shared/homebrew.common.nix
    ./shared/homebrew.private.nix
    ./shared/home.private.nix
    ./shared/fonts.nix
    ./shared/preferences.nix
  ];

  custom.preferences.blockAllIncoming = false;
  custom.preferences.dockTerminal = "/Applications/Rex Beta.app";

  documentation.enable = false;
  system.tools.darwin-uninstaller.enable = false;

  home-manager.users.${username} = {pkgs, ...}: {
    imports = [
      inputs.agent-skills.homeManagerModules.default
      ../../home/shared/profiles/darwin.nix
      ../../home/shared/private.nix
    ];

    home.packages = with pkgs; [
      zulu25
    ];

    programs.agentSkills = {
      enable = true;
      skills = inputs.agent-skills.profiles.private;
    };

    custom = {
      git.commitMessageModel = "gpt-5.6-luna";
      ghostty.fontSize = 21;
      rex.enable = true;
    };
  };
}
