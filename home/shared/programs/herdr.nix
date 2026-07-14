{
  pkgs,
  config,
  ...
}: {
  programs.herdr = {
    enable = true;
    package = pkgs.llm-agents.herdr;
  };
}
