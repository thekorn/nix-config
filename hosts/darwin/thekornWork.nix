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
      skills = {
        commit = inputs.agent-skills.skills.commit;
        grill-me = inputs.agent-skills.skills.grill-me;
        grilling = inputs.agent-skills.skills.grilling;
        html = inputs.agent-skills.skills.html;
        html-plan = inputs.agent-skills.skills.html-plan;
        html-diagram = inputs.agent-skills.skills.html-diagram;
        hunk-review = inputs.agent-skills.skills.hunk-review;
        web-browser = inputs.agent-skills.skills.web-browser;
        gitlab-workflow = inputs.agent-skills.skills.gitlab-workflow;
        glab = inputs.agent-skills.skills.glab;
      };
    };

    custom = {
      ghostty.fontSize = 19;
      workmux.defaultAgent = "cursor-agent";
    };
  };
}
