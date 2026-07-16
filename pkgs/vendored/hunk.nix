{
  lib,
  stdenvNoCC,
  fetchzip,
}: let
  # Use Hunk's prebuilt release archives instead of the upstream flake package.
  # The source package goes through Hunk's Bun dependency graph, which currently
  # evaluates x86_64-darwin dependencies on Apple Silicon and emits the Nixpkgs
  # 26.05 x86_64-darwin deprecation warning during darwin-rebuild. The prebuilt
  # archive is the same released CLI, keeps this configuration declarative, and
  # avoids that unrelated evaluation warning.
  version = "0.17.1";
  releases = {
    aarch64-darwin = {
      asset = "hunkdiff-darwin-arm64.tar.gz";
      hash = "sha256-v/NhLy8EX9xRntkwLuqEt7/OlTLjJpgxG7cksKqJVHY=";
    };
    aarch64-linux = {
      asset = "hunkdiff-linux-arm64.tar.gz";
      hash = "sha256-62MnqUDAyJsmsSnUFgvunFEQaUjpAitPXIhl7KmpoQU=";
    };
    x86_64-linux = {
      asset = "hunkdiff-linux-x64.tar.gz";
      hash = "sha256-IdezOc+tXmtg8RXx/9vk3oaSuoSSsWVWHJrY/iP/h9w=";
    };
  };
  release =
    releases.${stdenvNoCC.hostPlatform.system}
    or (throw "Unsupported Hunk system: ${stdenvNoCC.hostPlatform.system}");
in
  stdenvNoCC.mkDerivation {
    pname = "hunkdiff";
    inherit version;

    src = fetchzip {
      url = "https://github.com/modem-dev/hunk/releases/download/v${version}/${release.asset}";
      hash = release.hash;
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp -p hunk $out/bin/hunk
      cp -r skills $out/
      runHook postInstall
    '';

    meta = {
      description = "Terminal diff viewer for agentic changesets";
      homepage = "https://github.com/modem-dev/hunk";
      license = lib.licenses.mit;
      mainProgram = "hunk";
      platforms = builtins.attrNames releases;
    };
  }
