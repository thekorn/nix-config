{ pkgs, ... }: {
  users = {
    users = {
      thekorn = {
        home = "/home/thekorn";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        defaultUserShell = pkgs.zsh;
        packages = with pkgs; [ git neovim htop tree ];
      };
    };
  };
}
