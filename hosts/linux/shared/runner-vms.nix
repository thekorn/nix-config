{
  config,
  inputs,
  lib,
  pkgs,
  self,
  users,
  ...
}: let
  cfg = config.custom.runnerVMs;
  runnerOptions = name: port: {
    enable = lib.mkEnableOption "${name} runner VM";
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "Guest hostname (also the Amp runner ID).";
    };
    sshPort = lib.mkOption {
      type = lib.types.port;
      default = port;
      description = "Host loopback port forwarded to guest SSH.";
    };
  };
  mkVM = name: mac: guestModule: {
    pkgs = pkgs.extend inputs.microvm.overlay;
    specialArgs = {inherit inputs self users;};
    autostart = true;
    restartIfChanged = true;
    config = {
      imports = [guestModule];
      networking.hostName = cfg.${name}.hostName;
      microvm.interfaces = [
        {
          type = "user";
          id = name;
          inherit mac;
        }
      ];
      microvm.forwardPorts = [
        {
          from = "host";
          proto = "tcp";
          host.address = "127.0.0.1";
          host.port = cfg.${name}.sshPort;
          guest.port = 22;
        }
      ];
    };
  };
in {
  imports = [inputs.microvm.nixosModules.host];

  options.custom.runnerVMs = {
    github = runnerOptions "GitHub" 2221;
    amp = runnerOptions "Amp" 2222;
  };

  config.microvm.vms = lib.mkMerge [
    (lib.mkIf cfg.github.enable {
      github-runner = mkVM "github" "02:00:00:00:01:01" ./runner-vms/github.nix;
    })
    (lib.mkIf cfg.amp.enable {
      amp-runner = mkVM "amp" "02:00:00:00:01:02" ./runner-vms/amp.nix;
    })
  ];
}
