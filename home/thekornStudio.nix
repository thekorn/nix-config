{pkgs, ...}: {
  imports = [
    ../profiles/darwin-desktop.nix
    ../profiles/work.nix

    #./shared/programs/zig.nix
    #./shared/devel/ladybird.darwin.nix
    #./shared/devel/rpi.darwin.nix
  ];

  home.packages = with pkgs; [
    zulu25
    prismlauncher
    discord
    llm-agents.gemini-cli
  ];
}
