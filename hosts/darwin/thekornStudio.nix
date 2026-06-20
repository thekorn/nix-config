{
  pkgs,
  users,
  ...
}: {
  imports = [
    ./shared/homebrew.common.nix
    ./shared/homebrew.studio.nix
    ./shared/homebrew.private.nix
    ./shared/homebrew.ladybird.nix
    ./shared/home.private.nix
    ./shared/fonts.nix
    #./shared/preferences.nix
    (import ./shared/preferences.nix {
      inherit pkgs;
      username = users.private;
    })
  ];
  nix.enable = false;
  # this is a bug, remove once https://github.com/nix-community/home-manager/issues/8291 is fixed
  users.users.${users.private}.uid = 501;

  home-manager.users.${users.private} = {pkgs, ...}: {
    imports = [
      ../../home/shared/profiles/darwin.nix
      ../../home/shared/work.nix
      ../../home/shared/private.nix

      #./shared/programs/qmk.nix
      #./shared/programs/steam.nix
      # this would be great, but ladybird build fails with those
      # using homebrew for now
      #../../home/shared/devel/ladybird.darwin.nix
      # package not working, use homebrew
      #../../home/shared/devel/rpi.darwin.nix
    ];

    home.packages = with pkgs; [
      zulu25

      prismlauncher
      discord
      #llm-agents.gemini-cli
      llm-agents.cursor-agent
      #whatsapp-for-mac
    ];

    custom.ghostty.fontSize = 21;
  };
}
