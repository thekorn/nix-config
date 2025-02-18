{pkgs, ...}: {
  home.file = {".config/llm/llm.env".source = ./dotfiles/llm/llm.env;};
  home.packages = with pkgs; [
    llm
  ];
}
