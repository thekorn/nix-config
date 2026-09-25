{
  inputs,
  pkgs,
  self,
  users,
  ...
}: let
  guestBase = {
    imports = [
      ../../shared/home.private.nix
      ../../../shared/attic-cache.nix
    ];

    system.stateVersion = "25.11";
    time.timeZone = "Europe/Berlin";
    networking.useDHCP = true;

    programs.zsh.enable = true;
    programs.nix-ld.enable = true;
    security.sudo.wheelNeedsPassword = false;
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];

    microvm = {
      hypervisor = "qemu";
      vcpu = 4;
      mem = 8192;
      # Ship the guest closure as a disk, never expose host filesystems.
      storeOnDisk = true;
      shares = [];
      writableStoreOverlay = "/nix/.rw-store";
      volumes = [
        {
          image = "root.img";
          label = "root";
          mountPoint = "/";
          size = 65536;
        }
      ];
    };
  };
in {
  imports = [inputs.microvm.nixosModules.host];

  # The server has an AMD CPU. Expose SVM to QEMU so Android emulators
  # inside the GitHub guest can use their own /dev/kvm.
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
  '';

  microvm.vms = {
    github-runner = {
      pkgs = pkgs.extend inputs.microvm.overlay;
      specialArgs = {inherit users;};
      autostart = true;
      restartIfChanged = true;
      config = {
        imports = [guestBase];
        networking.hostName = "thekorn-github-runner";
        boot.kernelModules = ["kvm-amd"];

        microvm.interfaces = [
          {
            type = "user";
            id = "github";
            mac = "02:00:00:00:01:01";
          }
        ];
        microvm.forwardPorts = [
          {
            from = "host";
            proto = "tcp";
            host.address = "127.0.0.1";
            host.port = 2221;
            guest.port = 22;
          }
        ];

        services.github-runners.bunte-app = {
          enable = true;
          name = "thekorn-server-bunte-app";
          url = "https://github.com/thekorn/bunte-app";
          # Provision inside the guest as root:root, mode 0600.
          tokenFile = "/var/lib/github-runner-secrets/bunte-app.token";
          extraLabels = ["nixos" "thekorn-server"];
          extraPackages = [pkgs.iproute2];
          serviceOverrides = {
            PrivateDevices = false;
            DevicePolicy = "closed";
            DeviceAllow = ["/dev/kvm rw"];
            SupplementaryGroups = ["kvm"];
          };
        };
        # A newly provisioned VM should boot cleanly before its token is installed.
        systemd.services.github-runner-bunte-app.unitConfig.ConditionPathExists = "/var/lib/github-runner-secrets/bunte-app.token";
      };
    };

    amp-runner = {
      pkgs = pkgs.extend inputs.microvm.overlay;
      specialArgs = {inherit inputs self users;};
      autostart = true;
      restartIfChanged = true;
      config = {
        imports = [
          guestBase
          ../../shared/amp-runner.nix
          ../../shared/virtualisation.nix
          inputs.home-manager.nixosModules.home-manager
        ];
        networking.hostName = "thekorn-amp-runner";

        microvm.interfaces = [
          {
            type = "user";
            id = "amp";
            mac = "02:00:00:00:01:02";
          }
        ];
        microvm.forwardPorts = [
          {
            from = "host";
            proto = "tcp";
            host.address = "127.0.0.1";
            host.port = 2222;
            guest.port = 22;
          }
        ];

        users.users.${users.private}.linger = true;
        home-manager = {
          extraSpecialArgs = {inherit inputs self users;};
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bck";
          users.${users.private} = {
            imports = [
              ../../../../home/shared/profiles/linux-server.nix
              ../../../../home/shared/private.nix
              ../../../../home/shared/programs/attic.nix
            ];
            manual.manpages.enable = false;
            custom.git.commitMessageModel = "gpt-5.6-luna";
          };
        };
      };
    };
  };
}
