# config using nix and flake

This is the multi-machine configuration for my Darwin (macOS) and Linux systems, managed via Nix Flakes, nix-darwin, and home-manager.

## Prerequisites

- **Git**: Required to clone this repository.
- **Homebrew** (Darwin only): Used for managing some macOS applications.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- **Nix**: Install Nix with Flakes support.

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

## Setup

1. Clone this repository into `~/.config/nix`:

```bash
git clone https://github.com/thekorn/nix-config.git ~/.config/nix
cd ~/.config/nix
```

2. Apply the configuration for your host:

### Darwin (macOS)

For a first-time installation:

```bash
nix run nix-darwin -- switch --flake .#<hostname>
```

For subsequent updates:

```bash
darwin-rebuild switch --flake .#<hostname>
```

### Linux (NixOS)

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

To deploy a Linux host remotely from another machine on the network:

```bash
nix run .#deploy-thekorn-server
nix run .#deploy-thekorn-server-2
nix run .#deploy-thekorn-vm
nix run .#deploy-thekorn-vm-desktop
```

This connects to the matching `thekorn@<hostname>`, builds on the target, and activates the matching NixOS configuration there.

## Available Hosts

### Darwin

- `thekorn-macbook` (Personal MacBook)
- `thekorn-studio` (Personal Mac Studio)
- `BFG-043556` (Work Laptop, user: `d438477`)

### Linux

- `thekorn-server` (Main server)
- `thekorn-server-2` (Second server)
- `thekorn-vm` (VM)
- `thekorn-vm-desktop` (Desktop VM)

### Runner VMs on thekorn-server

The server manages two NixOS QEMU/KVM guests with `microvm.nix`:

| VM / host systemd unit | Runner | SSH port on host loopback |
| --- | --- | --- |
| `microvm@github-runner` | GitHub Actions: `thekorn-server-bunte-app` | 2221 |
| `microvm@amp-runner` | Amp: `thekorn-amp-runner` | 2222 |

Each guest has 4 vCPUs, 8 GiB RAM and a persistent 64 GiB root disk at
`/var/lib/microvms/<vm>/root.img`. Allow 16 GiB RAM for the guests **plus** host
headroom, and disk space for both root disks and generated Nix store images.
Resource defaults live in `hosts/linux/shared/runner-vms/base.nix`; changing the
configured disk size does not resize an existing disk.

Import `hosts/linux/shared/runner-vms.nix` to enable either reusable runner VM:

```nix
custom.runnerVMs.amp = {
  enable = true;
  hostName = "my-amp-runner"; # Also used as the Amp runner ID.
  sshPort = 2222; # Optional; GitHub defaults to 2221.
};
```

`custom.runnerVMs.github` has the same options. Configure GitHub registrations
through `microvm.vms.github-runner.config.services.github-runners`, as shown in
`hosts/linux/configurations/thekorn-server/runner-vms.nix`. Guest overrides such
as `microvm.vms.amp-runner.config.microvm.mem = 4096` use the standard microVM
options. Nested KVM settings remain host-specific.

The guests use outbound QEMU user-mode NAT, key-only SSH and the same authorized
key as the host. There are no host filesystem shares. Each guest has its own
writable Nix store; Amp also has the server home-manager profile and Docker.
The guest user `thekorn` has passwordless sudo **inside the guests only**.
NAT is not an outbound security policy: jobs can still reach the host and LAN.

#### First deployment and migration

1. Drain GitHub jobs and finish Amp threads on the old host runners. Back up any
   working data you need. Deploy this branch with `nix run .#deploy-thekorn-server`.
   This removes both host runner services and starts the VMs, but does not copy
   host credentials, repositories, or runner state into them.
2. On the host, verify `cat /sys/module/kvm_amd/parameters/nested` reports `1` or
   `Y`. The configuration enables nested AMD KVM; if the already-loaded module
   still has it disabled, reboot the server during a maintenance window. Do not
   unload KVM while VMs are running. Firmware virtualization must be enabled too.
3. Connect through the server from your workstation (no SSH agent forwarding is
   needed):

   ```bash
   ssh -J thekorn@thekorn-server.home -p 2221 thekorn@127.0.0.1
   ssh -J thekorn@thekorn-server.home -p 2222 thekorn@127.0.0.1
   ```

4. Once the old runner is stopped, remove its offline registration from the
   repository's GitHub Actions runner settings: the guest keeps the same name
   and does not automatically replace existing registrations. Create a fresh
   registration token for `thekorn/bunte-app` (tokens expire after one hour).
   Keep it in a protected local file, outside this repository. From the
   workstation, install it in the GitHub guest:

   ```bash
   ssh -J thekorn@thekorn-server.home -p 2221 thekorn@127.0.0.1 \
     'sudo install -d -m 0700 /var/lib/github-runner-secrets && sudo sh -c "umask 077; cat > /var/lib/github-runner-secrets/bunte-app.token"' \
     < /path/to/fresh-registration-token
   ssh -J thekorn@thekorn-server.home -p 2221 thekorn@127.0.0.1 \
     'sudo systemctl start github-runner-bunte-app'
   ```

   The service is skipped until that file exists. Its existing name, repository
   URL and labels (`nixos`, `thekorn-server`) are preserved. Registration state
   persists in the guest, but configuration/token changes may require a fresh
   registration token and removal of the previous offline registration.
   Job working directories retain the NixOS module's cleanup-on-start behavior.
5. In the Amp guest, run `sudo systemctl stop amp-runner`, then run `amp` as
   `thekorn` and complete sign-in. Exit the interactive CLI, clone or securely copy
   the required repositories under `/home/thekorn/devel`, then run
   `sudo systemctl start amp-runner`. Provision Git and other tool credentials
   separately; do not copy the entire host home or share its Docker socket.
   Select the new `thekorn-amp-runner` in Amp.

#### Operations and verification

Host rebuilds update both guest systems and restart guests whose configuration
changed. Drain jobs first: this is not a rolling or job-aware restart. Root disks
survive rebuilds, restarts and host reboots; back them up with the VM stopped.
The previous host runner data is left untouched. A NixOS generation rollback
does not roll back guest disks or GitHub registrations.

On the host, inspect `systemctl status microvm@github-runner microvm@amp-runner`
and `journalctl -u microvm@github-runner -u microvm@amp-runner`. In each guest,
inspect `systemctl status github-runner-bunte-app` or `systemctl status amp-runner`.
Verify `nix store ping --store daemon` works in both guests. In the GitHub guest,
check `/dev/kvm` exists, then run a real Android emulator workflow to verify nested
acceleration. ADB and emulator ports are guest-local and no longer conflict with
host sessions. Confirm both runners reconnect and Amp repositories survive after
a controlled guest restart. Neither VM boot nor nested KVM can be tested in an
Amp orb without `/dev/kvm`.

### Amp runner on thekorn-server-2

Amp is configured in a VM through `hosts/linux/shared/runner-vms.nix`, with
guest hostname and runner ID `thekorn-amp-runner-2`. Intel VT-x is now enabled
and `/dev/kvm` is available. Only the Amp VM is enabled on this server:

```nix
custom.runnerVMs.amp = {
  enable = true;
  hostName = "thekorn-amp-runner-2";
};
```

The guest defaults to host loopback SSH port 2222, 4 vCPUs, 8 GiB RAM, and a
64 GiB root disk at `/var/lib/microvms/amp-runner/root.img`. To migrate:

1. Finish active Amp threads and back up needed working data. Deploy with
   `nix run .#deploy-thekorn-server-2`. Activation removes the host `amp-runner`
   service and starts the guest; it does not copy credentials or repositories.
2. Connect with a distinct SSH host-key alias for this guest:

   ```bash
   ssh -J thekorn@thekorn-server-2.home -p 2222 \
     -o HostKeyAlias=thekorn-amp-runner-2 thekorn@127.0.0.1
   ```

3. Follow the Amp provisioning steps above: stop the guest service, sign in as
   `thekorn`, provision repositories under `/home/thekorn/devel` and tool
   credentials, then start the service. Select `thekorn-amp-runner-2` in Amp.
4. Verify the host `amp-runner.service` is absent, `microvm@amp-runner` is active,
   the guest runner reconnects, and repositories survive a guest restart.

Host files and USB/serial devices are not passed into the guest. Existing host
repositories remain untouched; migrate required working copies explicitly.

## Maintenance

- **Format code**: `nix fmt .`
- **Update inputs**: `nix flake update`

## Reference

- [nix-darwin manual](https://daiderd.com/nix-darwin/manual/index.html)
- [home-manager options](https://nix-community.github.io/home-manager/options.html)
- [Architecture details](./docs/architecture.md)

## TODO:

- Idea: move git commit hooks handling to lefthook https://lefthook.dev
