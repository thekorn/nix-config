{pkgs, ...}: {
  imports = [../../shared/runner-vms.nix];

  custom.runnerVMs = {
    github = {
      enable = true;
      hostName = "thekorn-github-runner";
    };
    amp = {
      enable = true;
      hostName = "thekorn-amp-runner";
    };
  };

  # Expose SVM so Android emulators in the GitHub guest can use /dev/kvm.
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
  '';
  microvm.vms.github-runner.config = {
    boot.kernelModules = ["kvm-amd"];
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
  };
}
