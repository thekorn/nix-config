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
