{
  pkgs,
  config,
  lib,
  ...
}: let
  gitHelpers = pkgs.writeShellScriptBin "git-helpers" ''
    HASH="%C(always,yellow)%h%C(always,reset)"
    RELATIVE_TIME="%C(always,green)%ar%C(always,reset)"
    AUTHOR="%C(always,bold blue)%an%C(always,reset)"
    REFS="%C(always,red)%d%C(always,reset)"
    SUBJECT="%s"

    FORMAT="$HASH $RELATIVE_TIME{$AUTHOR{$REFS $SUBJECT"

    pretty_git_log() {
      ${pkgs.git}/bin/git log --graph --pretty="tformat:$FORMAT" $* |
      column -t -s '{' |
      less -XRS --quit-if-one-screen
    }

    remove_untracked_files() {
      ${pkgs.git}/bin/git ls-files --other --exclude-standard | xargs rm -rf
    }
  '';
in {
  home.packages = [
    gitHelpers
  ];
  programs.git = {
    enable = true;
    userName = "Markus Korn";
    userEmail = "markus.korn@gmail.com";

    aliases = {
      co = "checkout";
      cm = "commit";
      st = "status";
      br = "branch";
      pu = "push -u";

      put = "push -u --tags";
      type = "cat-file -t";
      dump = "cat-file -p";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      diffc = "diff --cached";
      permission-reset = ''
        !git diff -p -R --no-color | grep -E "^(diff|(old|new) mode)" --color=never | git apply'';
      patch = "!git --no-pager diff --no-color";

      l = "!. ${gitHelpers}/bin/git-helpers && pretty_git_log";
      la = "!git l --all";
      lr = "!git l -30";
      lra = "!git lr --all";
      lgg = "!git l -G $1 -- $2";

      # list tags
      ltags = "!git for-each-ref --sort=creatordate --format '%(refname) %(creatordate)' refs/tags";
    };
    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "blue ol";
          commit-style = "raw";
          file-style = "omit";
          hunk-header-decoration-style = "blue box";
          hunk-header-file-style = "red";
          hunk-header-line-number-style = "#067a00";
          hunk-header-style = "file line-number syntax";
        };
        features = "chameleon";
        whitespace-error-style = "22 reverse";
        side-by-side = false;
        interactive = {keep-plus-minus-markers = true;};
      };
    };
    extraConfig = {
      #credential = {
      #  helper = "store";
      #};
      #gpg = {
      #  ssh = {
      #    defaultKeyCommand = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      #  };
      #};
      core = {
        editor = "nvim";
        whitespace = "trailing-space,space-before-tab";
      };
      push = {
        default = "current";
        followTags = true;
      };
      diff = {submodule = "log";};
      pull = {rebase = false;};
      init = {defaultBranch = "main";};
      commit = {
        # dont sign per default
        gpgsign = false;
      };
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
      {
        condition = "gitdir:**/bitbucket.org/burdastudios/**";
        contents = {
          user = {
            email = "markus.korn@burda.com";
            name = "Markus Korn";
          };
          core = {
            hooksPath = ".git/hooks";
          };
          # FIXME: default sign per 1password command not working
          commit = {gpgsign = false;};
          tag = {gpgsign = false;};
        };
      }
      {
        condition = "gitdir:**/gitlab.bfops.io/**";
        contents = {
          user = {
            email = "markus.korn@burda.com";
            name = "Markus Korn";
          };
          core = {
            hooksPath = ".git/hooks";
          };
          # FIXME: default sign per 1password command not working
          commit = {gpgsign = false;};
          tag = {gpgsign = false;};
        };
      }
    ];
  };
}
