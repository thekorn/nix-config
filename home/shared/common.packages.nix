{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    curl
    less
    zsh-forgit
    fnm
    awscli2
    silver-searcher
    jq
    htop
    delta
    httpie
    mkcert
    mongosh
    alejandra
    nixd
    ffmpeg
    lcov
    wget
    vlc-bin

    unar
    ktlint
    aria2
    clang-tools_18

    zed-editor
    bruno
    brave
    gimp-with-plugins
    #firefox #<- nix version is broken
    google-chrome
    raycast
    flutter
    nss
    swiftformat
    slumber
    cocoapods


    #ranger
  ];
}
