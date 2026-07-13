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
    # superfile

    unar
    ktlint
    aria2
    #llvmPackages_18.clang-tools

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

    llm-agents.cursor-agent
    llm-agents.opencode

    fvm

    glab
    gh
  ];
}
