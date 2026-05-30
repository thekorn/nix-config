{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [pkgs.llm-agents.workmux];
  # broken build, failing tests
  #home.packages = [inputs.workmux.packages.${pkgs.system}.default];

  xdg.configFile."workmux/config.yaml".text = ''
    nerdfont: true
    worktree_dir: ~/.local/share/workmux/{project}
    agent: amp
    panes:
      - command: <agent>
        focus: true
      - split: vertical
        size: 15
  '';
}
