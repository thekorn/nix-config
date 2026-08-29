{
  inputs,
  username,
  ...
}: {
  imports = [
    ./shared/homebrew.common.nix
    ./shared/homebrew.studio.nix
    ./shared/homebrew.private.nix
    ./shared/home.private.nix
    ./shared/fonts.nix
    ./shared/preferences.nix
    ../../home/shared/devel/ladybird.nix
  ];

  custom.preferences.blockAllIncoming = false;
  nix.enable = false;

  home-manager.users.${username} = {pkgs, ...}: {
    imports = [
      inputs.agent-skills.homeManagerModules.default
      ../../home/shared/profiles/darwin.nix
      ../../home/shared/work.nix
      ../../home/shared/private.nix

      #./shared/programs/qmk.nix
      #./shared/programs/steam.nix
      # package not working, use homebrew
      #../../home/shared/devel/rpi.darwin.nix
    ];

    home.packages = with pkgs; [
      zulu25

      prismlauncher
      discord

      keymapp
      #llm-agents.gemini-cli
      llm-agents.cursor-agent
      #whatsapp-for-mac
      uv
    ];

    programs.agentSkills = {
      enable = true;
      skills = inputs.agent-skills.profiles.private;
    };

    #custom.git.commitMessageTool = "amp";
    custom.git.commitMessageModel = "gpt-5.6-luna";
    custom.ghostty.fontSize = 21;
  };
}
