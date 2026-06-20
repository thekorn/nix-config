{users, ...}: {
  users.users.${users.private}.home = "/Users/${users.private}";

  services.tailscale.enable = false;
}
