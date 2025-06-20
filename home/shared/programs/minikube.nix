{pkgs, ...}: {
  programs.zsh.shellAliases = {
    "kubectl" = "minikube kubectl --";
  };
}
