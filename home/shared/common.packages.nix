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
    #delta
    httpie
    mkcert
    mongosh
    mongodb-tools
    alejandra
    nixd
    ffmpeg
    lcov
    wget
    # superfile

    unar
    ktlint
    aria2
    llvmPackages_18.clang-tools

    #bruno
    #brave
    #gimp-with-plugins
    firefox-bin-unwrapped
    raycast
    flutter
    nss
    swiftformat
    cocoapods
    nil

    llm-agents.opencode
    llm-agents.amp
    llm-agents.pi
    llm-agents.cursor-agent

    fvm
    bun

    glab
    television
  ];
}
