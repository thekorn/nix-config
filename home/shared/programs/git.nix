{
  imports = [
    ./git.common.nix
    ./hunk.nix
    ./git-amp-commit-message.nix
    ./git-cursor-commit-message.nix
    ({lib, ...}: {
      options.custom.git.commitMessageTool = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [
          "gptcommit"
          "cursor"
          "amp"
        ]);
        default = "gptcommit";
        description = "Tool used by the prepare-commit-msg hook to generate commit messages.";
      };
    })
  ];

  programs.git = {
    settings = {
      alias = {
        merges = "log --oneline --decorate --color=auto --merges --first-parent";

        # `git log` with patches shown
        dl = "log -p";
      };
      core = {
        pager = "less -R";
        autocrlf = "input";
      };
      pager = {
        diff = "hunk pager";
        show = "hunk pager";
      };
    };
    signing = {
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
    includes = [
      {
        condition = "gitdir:**/github.com/**";
        contents = {
          user = {
            email = "markus.korn@gmail.com";
            name = "Markus Korn";
            signingkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5L9M3eLZlZNQKyxGFKBRHkklhu4vK8eR4gj9JBb08a1K9tJ5UnWaETGHWq+UM3C5RdYcc5ZGAyc30/9nzxLskb9zi7xo6/Exhn2myMs3Bcwq0d1l/OeBTtdwKdP9YGfnVgNk7ZoPZtNygQCUsd1XWGfqgpw0mQW7BNc+W3U7+i5MeAhoOBC9NVqx8/q/CWPo89S63UPolsiQfrv4paYDakx+yT0M1Wkh6jXvIGNsVRGL4BuqFhYhh5pckmAnPMuBTAQV9jrV4GnpZIF/Y4EGOCKFgeseCMWzX8bDaNeNwZHxKUjmNYLW9nN5ZcQ0UnAap+YlSPH2pGuLgUaN7SNB0nwL1nAEtJEh7cYRufQ2HVZBqUxR/8NoreXGelio0qHbEnF5OMC78KwGry2XmuMfB+Mtvmg2CmHJwqI8z5Vr9hh6vwr7EJV5luKgwOGjdbPKocHQSfwTNg4zdRtrEeumIBYVkFOdV4sAdiIlB+Jtn+o3ZKCpyIGQEoqfglG3FrX6bbWpdL5Ls0t5+JsNnny/Rz2o6PNax84Fgab98seRhdK5nG1q8O+Woz9OnstAFjU+A9Ex0XhLBazsrfpnR0ZY9gfqpUBb2EfwlRS00WmE02ay+4t7rZfkohGcC16ZmJIt8hd/K1wKDSs/CS9q81VGstlHQjRiIPs+LqPsqr6HUzQ==";
          };
          commit = {gpgsign = true;};
        };
      }
      {
        condition = "gitdir:~/.config/nix";
        contents = {
          user = {
            email = "markus.korn@gmail.com";
            name = "Markus Korn";
            signingkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5L9M3eLZlZNQKyxGFKBRHkklhu4vK8eR4gj9JBb08a1K9tJ5UnWaETGHWq+UM3C5RdYcc5ZGAyc30/9nzxLskb9zi7xo6/Exhn2myMs3Bcwq0d1l/OeBTtdwKdP9YGfnVgNk7ZoPZtNygQCUsd1XWGfqgpw0mQW7BNc+W3U7+i5MeAhoOBC9NVqx8/q/CWPo89S63UPolsiQfrv4paYDakx+yT0M1Wkh6jXvIGNsVRGL4BuqFhYhh5pckmAnPMuBTAQV9jrV4GnpZIF/Y4EGOCKFgeseCMWzX8bDaNeNwZHxKUjmNYLW9nN5ZcQ0UnAap+YlSPH2pGuLgUaN7SNB0nwL1nAEtJEh7cYRufQ2HVZBqUxR/8NoreXGelio0qHbEnF5OMC78KwGry2XmuMfB+Mtvmg2CmHJwqI8z5Vr9hh6vwr7EJV5luKgwOGjdbPKocHQSfwTNg4zdRtrEeumIBYVkFOdV4sAdiIlB+Jtn+o3ZKCpyIGQEoqfglG3FrX6bbWpdL5Ls0t5+JsNnny/Rz2o6PNax84Fgab98seRhdK5nG1q8O+Woz9OnstAFjU+A9Ex0XhLBazsrfpnR0ZY9gfqpUBb2EfwlRS00WmE02ay+4t7rZfkohGcC16ZmJIt8hd/K1wKDSs/CS9q81VGstlHQjRiIPs+LqPsqr6HUzQ==";
          };
          commit = {gpgsign = true;};
        };
      }
    ];
  };
}
