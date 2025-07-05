{pkgs, ...}: {
  home.packages = with pkgs; [
    chatgpt
    #docker
    #colima
  ];
}
