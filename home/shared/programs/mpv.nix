{pkgs, ...}: {
  home.file.".local/bin/play-ls".source = ./bin/play-ls;
  home.packages = with pkgs; [
    mpv-unwrapped
    yt-dlp
  ];
}
