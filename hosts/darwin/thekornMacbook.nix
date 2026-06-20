{
  pkgs,
  users,
  ...
}: {
  imports = [
    ./shared/homebrew.common.nix
    ./shared/homebrew.private.nix
    ./shared/home.private.nix
    ./shared/fonts.nix
    (import ./shared/preferences.nix {
      inherit pkgs;
      username = users.private;
    })
  ];

  home-manager.users.${users.private} = {pkgs, ...}: {
    imports = [
      ../../home/shared/profiles/darwin.nix
      ../../home/shared/private.nix
    ];

    home.packages = with pkgs; [
      zulu25
      discord
      #llm-agents.gemini-cli
      #whatsapp-for-mac
    ];

    custom.ghostty.fontSize = 21;
  };
}
