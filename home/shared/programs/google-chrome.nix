{pkgs, ...}: {
  home.packages = with pkgs; [
    google-chrome
  ];
  programs.zsh = {
    sessionVariables = {
      #export for flutter
      CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
    };
  };
}
