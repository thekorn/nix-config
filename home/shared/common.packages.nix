{pkgs, ...}: {
  home.packages = with pkgs;
    [
      fd
      curl
      less
      nodejs_26
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
      fvm
      cocoapods
      nss
      nil

      llm-agents.cursor-agent
      llm-agents.opencode

      glab
      gh
      llm-agents.codegraph

      devenv
    ]
    # swift-collections fails to link on darwin (install_name_tool headerpad), so
    # swiftformat comes from homebrew there.
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [swiftformat];
}
