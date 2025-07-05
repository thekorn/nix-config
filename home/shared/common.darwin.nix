{pkgs, ...}: {
  home.packages = with pkgs; [
    chatgpt
    #tailscale
    #docker
    #colima
  ];
}
