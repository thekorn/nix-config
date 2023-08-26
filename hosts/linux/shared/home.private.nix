{ pkgs, ... }: {
  users = {
    users = {
      thekorn = {
        home = "/home/thekorn";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        packages = with pkgs; [ git neovim htop tree ];
      };
    };
  };
}
