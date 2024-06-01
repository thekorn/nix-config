{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    curl
    less
    zsh-forgit
    fnm
    awscli
    silver-searcher
    jq
    htop
    delta
    rustup
    httpie
    mkcert
    mongosh
    go
    alejandra
    ffmpeg
    lcov
    wget

    unar
    ktlint
    aria2
    clang-tools_18
  ];
}
