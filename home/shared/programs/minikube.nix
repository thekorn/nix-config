{pkgs, ...}: {
  home.packages = with pkgs; [
    minikube
  ];

  programs.zsh.shellAliases = {
    "kubectl" = "minikube kubectl --";
  };
}
