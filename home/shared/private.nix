{pkgs, ...}: {
  home.packages = with pkgs; [
    llm-agents.amp
    uv
  ];
  programs.discord.enable = false;
}
