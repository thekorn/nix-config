{
  username,
  pkgs,
  ...
}: {
  security.pki.certificateFiles = [
    ./fritz.box.pem
  ];
}
