{pkgs, ...}: {
  home.packages = with pkgs; [
    llm-agents.opencode
    llm-agents.amp
    #llm-agents.pi
  ];
}
