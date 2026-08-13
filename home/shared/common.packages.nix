{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    curl
    less
    awscli2
    jq
    htop
    httpie
    mkcert
    mongosh
    mongodb-tools
    alejandra
    nixd
    ffmpeg
    lcov
    wget

    unar
    ktlint
    aria2

    firefox-bin-unwrapped

    flutter
    nss
    swiftformat
    cocoapods
    nil

    llm-agents.cursor-agent
    llm-agents.opencode

    fvm

    glab
    gh
    llm-agents.codegraph
  ];
}
