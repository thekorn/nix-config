{pkgs, ...}: {
  home.packages = with pkgs; [
    minikube
  ];
}
