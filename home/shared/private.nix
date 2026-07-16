{pkgs, ...}: {
  home.packages = with pkgs; [
    llm-agents.amp
    llm-agents.codex
    #llm-agents.pi
  ];
}
