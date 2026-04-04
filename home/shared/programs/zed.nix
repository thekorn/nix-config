{...}: {
  programs.zsh = {
    shellAliases = {
      zed = "zeditor";
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = ["nix" "oxc" "tsgo" "codebook"];
    userSettings = {
      "edit_predictions" = {
        "provider" = "zed";
      };
      "buffer_font_size" = null;
      "features" = {
        "copilot" = false;
      };
      "telemetry" = {
        "metrics" = false;
        "diagnostics" = false;
      };
      "ui_font_size" = 15;
      "vim_mode" = false;
      "agent" = {
        "tool_permissions" = {
          "default" = "allow";
        };
        "default_model" = {
          "effort" = "high";
          "enable_thinking" = true;
          "model" = "claude-sonnet-4-6";
          "provider" = "zed.dev";
        };
        "inline_assistant_model" = {
          "model" = "claude-sonnet-4-6";
          "provider" = "zed.dev";
        };
      };
      "base_keymap" = "VSCode";
      "buffer_font_family" = "MonaspiceNe Nerd Font";
      "git" = {
        "inline_blame" = {
          "show_commit_summary" = true;
        };
      };
      "lsp" = {
        "eslint" = {
          "settings" = {
            "problems" = {
              "shortenToSingleLine" = true;
            };
          };
        };
      };
      "terminal" = {
        "dock" = "bottom";
        "env" = {
          "DISABLE_TMUX" = "1";
        };
        "line_height" = {
          "custom" = 1.15;
        };
      };
      "theme" = {
        "dark" = "Gruvbox Dark Hard";
        "light" = "Gruvbox Dark Hard";
        "mode" = "dark";
      };
    };
  };
}
