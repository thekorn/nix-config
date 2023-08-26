{ pkgs, ... }: {
  users = {
    users = {
      thekorn = {
        home = "/Users/thekorn";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        packages = with pkgs; [ git neovim htop tree ];
      };
    };
  };
}
