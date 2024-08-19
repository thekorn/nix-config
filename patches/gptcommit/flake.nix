{
  description = ''
    A git prepare-commit-msg hook for authoring commit messages with GPT-3.
  '';

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs) lib;
    forAllSystems = lib.genAttrs lib.systems.flakeExposed;
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      default = gptcommit1;
      gptcommit1 = pkgs.callPackage ./default.nix {};
    });

    #apps = forAllSystems (system: rec {
    #  default = gptcommit;
    #  gptcommit = {
    #    type = "app";
    #    program = "${lib.getBin self.packages.${system}.gptcommit}/bin/gptcommit";
    #  };
    #});
  };
}
