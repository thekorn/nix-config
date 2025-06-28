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
    mongodb-tools
    alejandra
    nixd
    ffmpeg
    lcov
    wget
    superfile

    unar
    ktlint
    aria2
    clang-tools_18

    bruno
    brave
    gimp-with-plugins
    #firefox #<- nix version is broken
    raycast
    flutter
    nss
    swiftformat
    cocoapods

    jujutsu
    jjui
  ];
}
