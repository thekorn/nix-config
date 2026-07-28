{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    #chatgpt
    #docker
    #colima
    pkgs.vendored.container
    inputs.tuicr.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
