{pkgs, ...}: {
  home.file = {".config/gptcommit/gptcommit.env".source = ./dotfiles/gptcommit/gptcommit.env;};
  home.file = {".config/gptcommit/config.toml".source = ./dotfiles/gptcommit/gptcommit.toml;};
  home.packages = with pkgs; [
    llm
  ];
}
