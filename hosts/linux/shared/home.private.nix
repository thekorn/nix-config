{pkgs, ...}: {
  users = {
    users = {
      thekorn = {
        home = "/home/thekorn";
        isNormalUser = true;
        extraGroups = ["wheel"];
        shell = pkgs.zsh;
        packages = with pkgs; [git htop tree];
      };
    };
  };
}
