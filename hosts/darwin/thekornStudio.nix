{
  inputs,
  pkgs,
  users,
  ...
}: {
  imports = [
    ./shared/homebrew.common.nix
    ./shared/homebrew.studio.nix
    ./shared/homebrew.private.nix
    ./shared/homebrew.ladybird.nix
    ./shared/home.private.nix
    ./shared/fonts.nix
    #./shared/preferences.nix
    (import ./shared/preferences.nix {
      inherit pkgs;
      username = users.private;
    })
  ];
  nix.enable = false;
  networking.hostName = "thekorn-studio";
  # this is a bug, remove once https://github.com/nix-community/home-manager/issues/8291 is fixed
  users.users.${users.private}.uid = 501;

  home-manager.users.${users.private} = {pkgs, ...}: {
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
      skills = {
        commit = inputs.agent-skills.skills.commit;
        grill-me = inputs.agent-skills.skills.grill-me;
        grilling = inputs.agent-skills.skills.grilling;
        html = inputs.agent-skills.skills.html;
        html-plan = inputs.agent-skills.skills.html-plan;
        html-diagram = inputs.agent-skills.skills.html-diagram;
        hunk-review = inputs.agent-skills.skills.hunk-review;
        web-browser = inputs.agent-skills.skills.web-browser;
      };
    };

    custom.ghostty.fontSize = 21;
  };
}
