{
  hostName,
  ipAddress,
  tapId,
  mac,
  vsockCid,
  workspace,
  inputs,
  userName,
  userHome,
  authorizedKeys,
  ampConfigDir,
  extraZshInit ? "",
}: {
  config,
  pkgs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  _module.args.microvmUserName = userName;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {inherit ampConfigDir userName userHome;};
  home-manager.users.${userName} = {
    imports = [./home.nix];
    microvm.extraZshInit = extraZshInit;
  };

  environment.systemPackages = [
    pkgs.eza
    pkgs.llm-agents.amp
  ];

  networking.hostName = hostName;
  system.stateVersion = "25.11";

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/host-keys/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  users.users.${userName} = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    home = userHome;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = authorizedKeys;
  };

  programs.zsh = {
    enable = true;
    shellAliases = config.home-manager.users.${userName}.programs.zsh.shellAliases;
  };

  services.resolved.enable = true;
  networking = {
    useDHCP = false;
    useNetworkd = true;
    tempAddresses = "disabled";
    nameservers = ["8.8.8.8" "1.1.1.1"];
    firewall.enable = false;
  };
  systemd.network = {
    enable = true;
    networks."10-e" = {
      matchConfig.Name = "e*";
      addresses = [{Address = "${ipAddress}/24";}];
      routes = [{Gateway = "192.168.83.1";}];
    };
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = "5s";

  systemd.mounts = [
    {
      what = "store";
      where = "/nix/store";
      overrideStrategy = "asDropin";
      unitConfig.DefaultDependencies = false;
    }
  ];

  microvm = {
    writableStoreOverlay = "/nix/.rw-store";
    volumes = [
      {
        mountPoint = "/var";
        image = "var.img";
        size = 8192;
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
      {
        proto = "virtiofs";
        tag = "ssh-keys";
        source = "${workspace}/ssh-host-keys";
        mountPoint = "/etc/ssh/host-keys";
      }
      {
        proto = "virtiofs";
        tag = "amp-config";
        source = ampConfigDir;
        mountPoint = "${userHome}/.config/amp";
      }
      {
        proto = "virtiofs";
        tag = "workspace";
        source = workspace;
        mountPoint = workspace;
      }
    ];
    interfaces = [
      {
        type = "tap";
        id = tapId;
        inherit mac;
      }
    ];
    hypervisor = "cloud-hypervisor";
    vcpu = 8;
    mem = 4096;
    socket = "control.socket";
    vsock.cid = vsockCid;
  };
}
