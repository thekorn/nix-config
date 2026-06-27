{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.hunk;

  # Use Hunk's prebuilt release archives instead of the upstream flake package.
  # The source package goes through Hunk's Bun dependency graph, which currently
  # evaluates x86_64-darwin dependencies on Apple Silicon and emits the Nixpkgs
  # 26.05 x86_64-darwin deprecation warning during darwin-rebuild. The prebuilt
  # archive is the same released CLI, keeps this configuration declarative, and
  # avoids that unrelated evaluation warning.
  hunkVersion = "0.16.0";
  hunkRelease = {
    aarch64-darwin = {
      asset = "hunkdiff-darwin-arm64.tar.gz";
      hash = "sha256-RUY9g9gFBHRm8UICwbeMir54otFZCMuwoR4EMuOQ/Bg=";
    };
    aarch64-linux = {
      asset = "hunkdiff-linux-arm64.tar.gz";
      hash = "sha256-Ra0VlUlnf7QThsLMe7hmKvmyVKgTOpEj7Jm8b0j/0GU=";
    };
    x86_64-linux = {
      asset = "hunkdiff-linux-x64.tar.gz";
      hash = "sha256-E2BsfyyTWxo3C7n3dEzHWcKPWLajKQQwlG3n1DIisHs=";
    };
  };
  hunkReleaseForSystem =
    hunkRelease.${pkgs.stdenv.hostPlatform.system}
    or (throw "Unsupported Hunk system: ${pkgs.stdenv.hostPlatform.system}");
  hunkPackage = pkgs.stdenvNoCC.mkDerivation {
    pname = "hunkdiff";
    version = hunkVersion;
    src = pkgs.fetchzip {
      url = "https://github.com/modem-dev/hunk/releases/download/v${hunkVersion}/${hunkReleaseForSystem.asset}";
      hash = hunkReleaseForSystem.hash;
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
      license = pkgs.lib.licenses.mit;
      mainProgram = "hunk";
      platforms = builtins.attrNames hunkRelease;
    };
  };
in {
  imports = [
    (inputs.hunk + "/nix/home-manager.nix")
  ];

  options.custom.hunk.useCustomPackage = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Whether to use the local prebuilt Hunk package instead of Hunk's upstream
      flake package. The custom package avoids an unrelated x86_64-darwin
      deprecation warning during darwin-rebuild.
    '';
  };

  config.programs.hunk = {
    enable = true;
    enableGitIntegration = false;
    package =
      if cfg.useCustomPackage
      then hunkPackage
      else inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      theme = "github-dark-default";
      mode = "split";
      line_numbers = true;
    };
  };
}
