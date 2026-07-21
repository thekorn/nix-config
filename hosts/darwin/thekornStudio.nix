{
  inputs,
  username,
  ...
}: {
  imports = [
    ./shared/homebrew.common.nix
    ./shared/homebrew.studio.nix
    ./shared/homebrew.private.nix
    ./shared/homebrew.ladybird.nix
    ./shared/home.private.nix
    ./shared/fonts.nix
    ./shared/preferences.nix
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
      # this would be great, but ladybird build fails with those
      # using homebrew for now
      #../../home/shared/devel/ladybird.darwin.nix
      # package not working, use homebrew
      #../../home/shared/devel/rpi.darwin.nix
    ];

    home.packages = with pkgs; [
      zulu25

      prismlauncher
      discord
      #llm-agents.gemini-cli
      llm-agents.cursor-agent
      #whatsapp-for-mac
    ];

    programs.agentSkills = {
      enable = true;
      skills = inputs.agent-skills.profiles.private;
    };

    #custom.git.commitMessageTool = "amp";
    custom.ghostty.fontSize = 21;
  };
}
