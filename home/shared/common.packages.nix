{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    curl
    less
    zsh-forgit
    fnm
    #awscli2 <-- broken (see: https://github.com/NixOS/nixpkgs/issues/367876, check https://nixpk.gs/pr-tracker.html?pr=367979 to re-enable)
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

    unar
    ktlint
    aria2
    clang-tools_18

    #ranger
  ];
}
