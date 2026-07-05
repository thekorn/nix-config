{
  config,
  inputs,
  lib,
  pkgs,
  users,
  ...
}: let
  microvmBase = import ./microvm/base.nix;

  userName = users.private;
  userHome = config.users.users.${userName}.home;
  workspaceRoot = "${userHome}/.local/share/microvm";
  ampConfigDir = "${userHome}/.local/share/amp-microvm";
  authorizedKeys = config.users.users.${userName}.openssh.authorizedKeys.keys;

  mkHostKeyPreStart = workspace: ''
    install -d -m 0755 -o ${userName} -g users ${workspace}
    install -d -m 0755 -o ${userName} -g users ${workspace}/ssh-host-keys
    install -d -m 0700 -o ${userName} -g users ${ampConfigDir}
    if [ ! -e ${workspace}/ssh-host-keys/ssh_host_ed25519_key ]; then
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -f ${workspace}/ssh-host-keys/ssh_host_ed25519_key
    fi
    chown ${userName}:users ${workspace}/ssh-host-keys/ssh_host_ed25519_key ${workspace}/ssh-host-keys/ssh_host_ed25519_key.pub
  '';
in {
  imports = [inputs.microvm.nixosModules.host];

  options.enableMicrovm = lib.mkEnableOption "coding-agent MicroVMs";

  config = lib.mkIf config.enableMicrovm {
    networking.nat = {
      enable = true;
      internalInterfaces = ["microbr"];
      externalInterface = "enp4s0";
    };

    systemd.network = {
      enable = true;
      netdevs."20-microbr".netdevConfig = {
        Kind = "bridge";
        Name = "microbr";
      };
      networks = {
        "20-microbr" = {
          matchConfig.Name = "microbr";
          addresses = [{Address = "192.168.83.1/24";}];
          networkConfig.ConfigureWithoutCarrier = true;
        };
        "21-microvm-tap" = {
          matchConfig.Name = "microvm*";
          networkConfig.Bridge = "microbr";
        };
      };
    };

    microvm.vms.zigvm = {
      autostart = false;
      config = {
        imports = [
          inputs.microvm.nixosModules.microvm
          (microvmBase {
            hostName = "zigvm";
            ipAddress = "192.168.83.6";
            tapId = "microvm4";
            mac = "02:00:00:00:00:05";
            vsockCid = 6;
            workspace = "${workspaceRoot}/zig";
            inherit inputs userName userHome authorizedKeys ampConfigDir;
          })
          ./microvm/vms/zig.nix
        ];
      };
    };

    systemd.services.install-microvm-zigvm.preStart = mkHostKeyPreStart "${workspaceRoot}/zig";
    systemd.services."microvm-virtiofsd@zigvm".preStart = mkHostKeyPreStart "${workspaceRoot}/zig";
  };
}
