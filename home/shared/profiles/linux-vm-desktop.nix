{
  imports = [
    ./linux-vm.nix
    ../programs/waybar.nix
    ../programs/xdg.nix
    ../programs/wayland.nix
  ];

  custom.ghostty.enable = true;
}
