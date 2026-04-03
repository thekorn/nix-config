{pkgs, ...}: {
  home.packages = with pkgs; [pnpm];
  home.sessionVariables = {
    # pnpm
    PNPM_HOME = "$HOME/.local/share/pnpm";
  };
  home.sessionPath = ["$PNPM_HOME"];
}
