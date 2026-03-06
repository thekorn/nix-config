{pkgs, ...}: {
  imports = [
    ../profiles/darwin-desktop.nix

    ./shared/programs/zig.nix
  ];

  home.packages = with pkgs; [
    zulu25
    discord
    llm-agents.gemini-cli
  ];
}
