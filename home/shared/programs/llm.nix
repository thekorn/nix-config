{pkgs, ...}: {
  home.file = {".config/llm/llm.env".source = ./dotfiles/llm/llm.env;};
  home.packages = with pkgs; [
    #(pkgs.callPackage ./vendor/gptcommit.thekorn.nix {inherit (pkgs.darwin.apple_sdk.frameworks) Security SystemConfiguration;})
    gptcommit
  ];
}
