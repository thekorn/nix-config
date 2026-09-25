{
  inputs,
  self,
  users,
  ...
}: {
  imports = [
    ./base.nix
    ../amp-runner.nix
    ../virtualisation.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.${users.private}.linger = true;
  home-manager = {
    extraSpecialArgs = {inherit inputs self users;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bck";
    users.${users.private} = {
      imports = [
        ../../../../home/shared/profiles/linux-server.nix
        ../../../../home/shared/private.nix
        ../../../../home/shared/programs/attic.nix
      ];
      manual.manpages.enable = false;
      custom.git.commitMessageModel = "gpt-5.6-luna";
    };
  };
}
