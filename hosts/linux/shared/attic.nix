{pkgs, ...}: let
  environmentFile = "/var/lib/atticd-token.env";
in {
  services.atticd = {
    enable = true;
    inherit environmentFile;

    settings = {
      listen = "0.0.0.0:8080";
      allowed-hosts = ["thekorn-server.home:8080"];
      api-endpoint = "http://thekorn-server.home:8080/";

      compression.type = "zstd";
      garbage-collection.interval = "1 day";
    };
  };

  # Keep the JWT signing secret out of the Nix store and Git. Attic stores
  # each cache's separate Nix signing key in its database.
  system.activationScripts.atticd-token.text = ''
    if [[ ! -s ${environmentFile} ]]; then
      (
        umask 077
        token="$(${pkgs.openssl}/bin/openssl genrsa -traditional 4096 | ${pkgs.coreutils}/bin/base64 -w0)"
        printf 'ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=%s\n' "$token" > ${environmentFile}.new
        mv ${environmentFile}.new ${environmentFile}
      )
    fi
  '';

  networking.firewall.allowedTCPPorts = [8080];

  environment.systemPackages = [pkgs.attic-client];
}
