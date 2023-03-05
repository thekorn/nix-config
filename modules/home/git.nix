{ pkgs, config, ... }:
{
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
      type = "cat-file -t";
      dump = "cat-file -p";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      diffc = "diff --cached";
      permission-reset = "!git diff -p -R --no-color | grep -E \"^(diff|(old|new) mode)\" --color=never | git apply";
      patch = "!git --no-pager diff --no-color";
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
        interactive = {
          keep-plus-minus-markers = true;
        };
      };
    };
    extraConfig = {
      #credential = {
	    #  helper = "store";
      #};
      core = {
        editor = "nvim";
        whitespace = "trailing-space,space-before-tab";
      };
      push = {
        default = "current";
        followTags = true;
      };
      diff = {
        submodule = "log";
      };
      pull = {
        rebase = false;
      };
      init = {
        defaultBranch = "main";
      };
    };
    includes = [
      {
        condition = "gitdir:**/github.com/**";
        contents = {
          user = {
            email = "markus.korn@gmail.com";
            name = "Markus Korn";
          };
          core = {
            sshCommand = "ssh -i ~/.ssh/keys/id_rsa";
          };
        };
      }
      {
        condition = "gitdir:~/.config/nix";
        contents = {
          user = {
            email = "markus.korn@gmail.com";
            name = "Markus Korn";
          };
          core = {
            sshCommand = "ssh -i ~/.ssh/keys/id_rsa";
          };
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
            sshCommand = "sshCommand = ssh -i ~/.ssh/keys/id_rsa.bitbucket.burdastudios";
          };
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
            sshCommand = "sshCommand = ssh -i ~/.ssh/keys/id_ed25519.gitlab.burdaforward";
          };
        };
      }
    ];
  };
}