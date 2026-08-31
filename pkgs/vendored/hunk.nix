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
  version = "0.20.1";
  releases = {
    aarch64-darwin = {
      asset = "hunkdiff-darwin-arm64.tar.gz";
      hash = "sha256-ostOW0DN+5R8koLV6WhFapIYP0B4QiwZXaMoyuGe+N4=";
    };
    aarch64-linux = {
      asset = "hunkdiff-linux-arm64.tar.gz";
      hash = "sha256-G0bVp7MhU8lsjCeyyfNzbo9bA0U65Noo9TJXZ5QaWgE=";
    };
    x86_64-linux = {
      asset = "hunkdiff-linux-x64.tar.gz";
      hash = "sha256-SLPo47Ho4vSwzvzUhwtiYtob+G6ULDecPjZkZMTKEaA=";
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
