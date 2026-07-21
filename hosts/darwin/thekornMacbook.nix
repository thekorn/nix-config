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
      discord
      #llm-agents.gemini-cli
      #whatsapp-for-mac
    ];

    programs.agentSkills = {
      enable = true;
      skills = inputs.agent-skills.profiles.private;
    };

    custom.ghostty.fontSize = 21;
  };
}
