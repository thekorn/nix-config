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
  version = "7061475";
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "thekorn";
      repo = pname;
      rev = "${version}";
      hash = "sha256-DZsUmZO1dr+aS7Aa+DmP1G5lDlomQpmFdN+q/rYly5k=";
    };

    cargoHash = "sha256-+/255qFHUROUb19rWCrSYRW9Ii5EKjvWIAwMlY+q0IY=";

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
