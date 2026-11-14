{pkgs, ...}: {
  home.packages = with pkgs; [
    llm-agents.amp
    llm-agents.claude-code
    uv
  ];
  programs.discord.enable = true;
}
