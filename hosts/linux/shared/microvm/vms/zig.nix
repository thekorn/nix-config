{
  microvmUserName,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
    ripgrep
  ];

  #home-manager.users.${microvmUserName}.programs.emacs = {
  #  enable = true;
  #  package = pkgs.emacs;
  #};
}
