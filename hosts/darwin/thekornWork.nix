{
  inputs,
  username,
  ...
}: {
  imports = [
    ./shared/homebrew.common.nix
    ./shared/homebrew.work.nix
    ./shared/home.work.nix
    ./shared/fonts.nix
    ./shared/preferences.nix
  ];
  nix.enable = false;
  ids.gids.nixbld = 30000;

  home-manager.users.${username} = {pkgs, ...}: {
    imports = [
      inputs.agent-skills.homeManagerModules.default
      ../../home/shared/profiles/darwin.nix
      ../../home/shared/work.nix
    ];

    home.packages = with pkgs; [
      zulu17
    ];

    programs.agentSkills = {
      enable = true;

      skills = inputs.agent-skills.profiles.work;
    };

    custom = {
      ghostty.fontSize = 19;
      workmux.defaultAgent = "cursor-agent";
    };
  };
}
