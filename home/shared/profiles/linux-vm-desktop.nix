{pkgs, ...}: {
  imports = [
    ./linux-vm.nix
    ../programs/alacritty.nix
  ];

  home.packages = with pkgs; [
    firefox
    grim
    mako
    slurp
    waybar
    wl-clipboard
    wofi
  ];

  programs.waybar.enable = true;
  services.mako.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    xwayland.enable = true;
    settings = {
      "$mod" = "SUPER";

      monitor = [",preferred,auto,1"];

      exec-once = [
        "waybar"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur.enabled = false;
      };

      animations.enabled = false;

      bind = [
        "$mod, Return, exec, alacritty"
        "$mod, D, exec, wofi --show drun"
        "$mod, F, exec, firefox"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      ];
    };
  };
}
