{pkgs, ...}: {
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = ["thekorn"];
  #environment = {
  #  systemPackages = [pkgs.minikube];
  #};
  #
  #systemd.services.minikube = {
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
  #

  environment.systemPackages = with pkgs; [kubernetes-helm];

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    "--debug" # Optionally add additional args to k3s
    "--write-kubeconfig-mode 644"
  ];

  environment.variables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };
  networking.hosts = {
    "127.0.0.1" = ["hello.local"];
  };
}
