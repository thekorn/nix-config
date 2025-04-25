{pkgs, ...}: {
  programs.zsh = {
    initContent = ''
      ## [Completion]
      ## Completion scripts setup. Remove the following line to uninstall
      [[ -f ~/.dart-cli-completion/zsh-config.zsh ]] && . ~/.dart-cli-completion/zsh-config.zsh || true
      ## [/Completion]
    '';
  };
}
