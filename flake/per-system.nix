{mkPkgs, ...}: {
  perSystem = {system, ...}: let
    pkgs = mkPkgs system;
  in {
    _module.args.pkgs = pkgs;

    formatter = pkgs.alejandra;
  };
}
