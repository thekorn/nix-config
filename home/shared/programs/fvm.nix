{pkgs, ...}: {
  home.sessionVariables = {
    FVM_CACHE_PATH = "$HOME/.local/state/fvm";
  };
}
