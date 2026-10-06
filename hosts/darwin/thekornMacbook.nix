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

    custom.git.commitMessageModel = "gpt-5.6-luna";
    custom.ghostty.fontSize = 21;
  };
}
