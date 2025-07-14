{pkgs, ...}: {
  users = {users = {thekorn = {home = "/Users/thekorn";};};};

  services.tailscale.enable = false;
}
