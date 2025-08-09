{
  # Darwin machines
  "thekorn-macbook" = {
    type = "darwin";
    user = "thekorn";
    system = "aarch64-darwin";
    profiles = ["private" "development"];
    hostConfig = "thekornMacbook";
    homeConfig = "thekornMacbook";
  };

  "thekorn-studio" = {
    type = "darwin";
    user = "thekorn";
    system = "aarch64-darwin";
    profiles = ["private" "development" "studio" "gaming"];
    hostConfig = "thekornStudio";
    homeConfig = "thekornStudio";
  };

  "BFG-024849" = {
    type = "darwin";
    user = "d438477";
    system = "aarch64-darwin";
    profiles = ["work" "development"];
    hostConfig = "thekornWork";
    homeConfig = "thekornWork";
  };

  # NixOS machines
  "thekorn-server" = {
    type = "nixos";
    user = "thekorn";
    system = "x86_64-linux";
    profiles = ["server" "private"];
    hostConfig = "thekorn-server";
    homeConfig = "thekornServer";
  };

  "thekorn-server2" = {
    type = "nixos";
    user = "thekorn";
    system = "x86_64-linux";
    profiles = ["server" "private"];
    hostConfig = "thekorn-server2";
    homeConfig = "thekornServer2";
  };
}