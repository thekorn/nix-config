{
  description = "My NixOS config";

  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/2175e5c";
    #nixpkgs.url = "github:nixos/nixpkgs/master";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    omarchy-nix = {
      url = "github:thekorn/omarchy-nix";
      #url = "path:/home/thekorn/.config/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";
    workmux.url = "github:raine/workmux";

    config-nvim = {
      url = "git+ssh://git@github.com/thekorn/config.nvim.git";
      flake = false;
    };

    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./flake];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];
    };
}
