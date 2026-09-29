{pkgs, ...}: {
  # Flutter supplies its matching Dart SDK; avoid a second, mismatched Dart.
  packages = [pkgs.flutter pkgs.fvm] ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [pkgs.cocoapods];

  env.DEVENV_TOOLBOX = "flutter";

  enterShell = ''
    export FVM_CACHE_PATH="$HOME/.local/state/fvm"
    export PATH="$PATH:$HOME/.pub-cache/bin"
  '';
}
