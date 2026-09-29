{pkgs, ...}: {
  # Flutter supplies its matching Dart SDK; avoid a second, mismatched Dart.
  packages = [pkgs.flutter pkgs.fvm];

  env.DEVENV_TOOLBOX = "flutter";

  enterShell = ''
    export FVM_CACHE_PATH="$HOME/.local/state/fvm"
    export PATH="$PATH:$HOME/.pub-cache/bin"
  '';
}
