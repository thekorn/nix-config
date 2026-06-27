{
  #programs.zsh = {initContent = ''eval "$(atuin init zsh)"'';};
  programs.atuin = {
    enable = true;
    settings = {
      style = "compact";
      enter_accept = true;
    };
    enableZshIntegration = true;
  };
}
