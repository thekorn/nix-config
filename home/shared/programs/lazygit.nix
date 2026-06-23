{pkgs, ...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
        showRandomTip = false;
        notARepository = "quit";
      };
    };
  };
}
