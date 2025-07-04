{pkgs, ...}: {
  programs.zsh.shellAliases = {
    "kubectl" = "minikube kubectl --";
  };

  #home.packages = [pkgs.minikube];
  #
  #systemd.user.services.minikube = {
  #  # https://joepreludian.medium.com/how-to-start-up-minikube-automatically-via-system-d-2cad99fd79bf
  #  wantedBy = ["multi-user.target"];
  #  after = ["docker.service"];
  #  description = "start minikube";
  #  path = [pkgs.docker];
  #  serviceConfig = {
  #    Type = "oneshot";
  #    User = "thekorn";
  #    Group = "users";
  #    ExecStart = ''${pkgs.minikube}/bin/minikube start --driver=docker'';
  #    ExecStop = ''${pkgs.minikube}/bin/minikube stop'';
  #    RemainAfterExit = true;
  #    StandardOutput = "journal";
  #  };
  #};
}
