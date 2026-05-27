{pkgs, ...}: {
  home.packages = with pkgs; [
    llm-agents.opencode
    llm-agents.amp
    llm-agents.workmux
    #llm-agents.pi
  ];
}
