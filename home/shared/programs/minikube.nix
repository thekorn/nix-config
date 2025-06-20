{pkgs, ...}: {
  #home.packages = with pkgs; [
  #  minikube
  #];

  programs.zsh.shellAliases = {
    "kubectl" = "minikube kubectl --";
  };

  #systemd.services.minikube = {
  #  # https://joepreludian.medium.com/how-to-start-up-minikube-automatically-via-system-d-2cad99fd79bf
  #  # this service is "wanted by" (see systemd man pages, or other tutorials) the system
  #  # level that allows multiple users to login and interact with the machine non-graphically
  #  # (see the Red Hat tutorial or Arch Linux Wiki for more information on what each target means)
  #  # this is the "node" in the systemd dependency graph that will run the service
  #  wantedBy = ["multi-user.target"];
  #  # systemd service unit declarations involve specifying dependencies and order of execution
  #  # of systemd nodes; here we are saying that we want our service to start after the network has
  #  # set up (as our IRC client needs to relay over the network)
  #  after = ["docker.service"];
  #  description = "start minikube";
  #  serviceConfig = {
  #    # see systemd man pages for more information on the various options for "Type": "notify"
  #    # specifies that this is a service that waits for notification from its predecessor (declared in
  #    # `after=`) before starting
  #    Type = "oneshot";
  #    # username that systemd will look for; if it exists, it will start a service associated with that user
  #    User = "thekorn";
  #    group = "users";
  #    # the command to execute when the service starts up
  #    ExecStart = ''${pkgs.minikube}/bin/minikube start --driver=docker'';
  #    # and the command to execute
  #    ExecStop = ''${pkgs.minikube}/bin/minikube stop'';
  #    RemainAfterExit = true;
  #    StandardOutput = "journal";
  #  };
  #};
}
