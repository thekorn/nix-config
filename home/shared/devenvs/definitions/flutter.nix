{pkgs, ...}: let
  appleTools = pkgs.runCommand "flutter-apple-tools" {} ''
    mkdir -p "$out/bin"
    ln -s /usr/bin/xcrun "$out/bin/xcrun"
  '';
in {
  # Flutter supplies its matching Dart SDK; avoid a second, mismatched Dart.
  packages = [pkgs.flutter pkgs.fvm] ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [pkgs.cocoapods];

  env.DEVENV_TOOLBOX = "flutter";

  enterShell =
    ''
      export FVM_CACHE_PATH="$HOME/.local/state/fvm"
      export PATH="$PATH:$HOME/.pub-cache/bin"
    ''
    + pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      # Flutter needs Apple's xcrun to discover Xcode and iOS simulators.
      # Override only xcrun, preserving Nix precedence for other tools.
      export PATH="${appleTools}/bin:$PATH"

      # Use the selected Xcode's SDKs instead of Nix's macOS-only SDK.
      # Swift Package Manager also compiles its manifests against this SDK.
      unset DEVELOPER_DIR SDKROOT

      # Let Xcode choose its compiler and linker, not Nix's wrappers or raw ld.
      unset CC CXX LD
    '';
}
