# override to fix https://github.com/zurawiki/gptcommit/pull/285
{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  nix-update-script,
  Security,
  SystemConfiguration,
  openssl,
}: let
  pname = "gptcommit";
  version = "main";
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "thekorn";
      repo = pname;
      rev = "${version}";
      hash = "sha256-xzAydOmhaV/+tnWd1211irMGCxDB6vtX1hDaiCF9fjk=";
    };

    cargoHash = "sha256-m6JTmVCZzN5elwk8k9BK0Z+HcuvhQWcYbo+ZvA9w4Vo=";

    nativeBuildInputs = [pkg-config];

    # 0.5.6 release has failing tests
    doCheck = false;

    buildInputs =
      lib.optionals stdenv.hostPlatform.isDarwin [Security SystemConfiguration]
      ++ lib.optionals stdenv.hostPlatform.isLinux [openssl];

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
