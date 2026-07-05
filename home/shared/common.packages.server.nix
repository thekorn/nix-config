{pkgs, ...}: {
  # specify my home-manager configs
  home.packages = with pkgs; [
    fd
    curl
    less
    awscli2
    jq
    htop
    #delta
    httpie
    alejandra
    nixd
    unzip
    gnumake
    tree-sitter

    glab
    fosrl-newt
    television
  ];
}
