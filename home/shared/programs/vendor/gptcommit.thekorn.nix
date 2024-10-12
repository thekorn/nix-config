{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  nix-update-script,
  Security,
  SystemConfiguration,
}: let
  pname = "gptcommit";
  version = "master";
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "thekorn";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-xzAydOmhaV/+tnWd1211irMGCxDB6vtX1hDaiCF9fjk=";
    };

    cargoHash = "sha256-5KdLlgnIVuxzM/fysGT1iUwtm0oetipIA0mlZ80OuNM=";

    nativeBuildInputs = [pkg-config];

    # 0.5.6 release has failing tests
    doCheck = false;

    buildInputs =
      lib.optionals stdenv.hostPlatform.isDarwin [Security SystemConfiguration];
    #++ lib.optionals stdenv.hostPlatform.isLinux [openssl];

    passthru = {
      updateScript = nix-update-script {};
    };

    meta = with lib; {
      description = "Git prepare-commit-msg hook for authoring commit messages with GPT-3.";
      mainProgram = "gptcommit";
      homepage = "https://github.com/zurawiki/gptcommit";
      license = with licenses; [asl20];
      maintainers = with maintainers; [happysalada];
      platforms = with platforms; all;
    };
  }
