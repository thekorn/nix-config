{pkgs, ...}: {
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--max-columns=150"
      "--max-columns-preview"

      # Add my 'web' type.
      "--type-add"
      "web:*.{html,css,js}*"

      # Add my 'ts' type.
      "--type-add"
      "ts:*.{ts,tsx,vue}"

      # Because who cares about case!?
      "--smart-case"
    ];
  };
}
