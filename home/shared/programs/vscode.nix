{pkgs, ...}: {
  programs.vscode = {
    enable = false;
    profiles.default.userSettings = {
      "workbench.colorTheme" = "Nord";
      "editor.suggestSelection" = "first";
      "files.exclude" = {
        "**/.classpath" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/.factorypath" = true;
      };
      "[json]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "redhat.telemetry.enabled" = false;
      "editor.fontFamily" = "'GeistMono Nerd Font', 'CaskaydiaCove NF', 'cascadia code pl', 'MesloLGS NF'";
      "terminal.integrated.profiles.linux" = {
        "zsh (to-tmux)" = {
          "path" = "zsh";
          "env" = {
            "IS_VSCODETERMINAL" = "1";
          };
        };
      };
      "terminal.integrated.defaultProfile.linux" = "zsh (to-tmux)";
      "[dockercompose]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
        "editor.autoIndent" = "advanced";
        "editor.quickSuggestions" = {
          "other" = true;
          "comments" = false;
          "strings" = true;
        };
      };
      "[typescript]" = {
        "editor.tabSize" = 2;
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "explorer.confirmDelete" = false;
      "security.workspace.trust.untrustedFiles" = "open";
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "explorer.confirmDragAndDrop" = false;
      "eslint.debug" = true;
      "editor.fontSize" = 12;
      "terminal.integrated.fontSize" = 12;
      "terminal.integrated.fontFamily" = "'GeistMono Nerd Font', 'CaskaydiaCove NFM', 'cascadia mono pl', 'MesloLGS NF'";
      "vetur.trace.server" = "verbose";
      "emmet.includeLanguages" = {};
      "workbench.editor.splitInGroupLayout" = "vertical";
      "workbench.startupEditor" = "none";
      "[html]" = {
        "editor.defaultFormatter" = "vscode.html-language-features";
      };
      "[nix]" = {
        "editor.tabSize" = 2;
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "editor.fontLigatures" = true;
      "eslint.format.enable" = true;
      "prettier.enable" = false;
      "[javascript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "dart.debugExternalPackageLibraries" = true;
      "dart.debugSdkLibraries" = true;
      "gitlens.plusFeatures.enabled" = false;
      "settingsSync.ignoredExtensions" = [
        "bbenoist.nix"
        "brettm12345.nixfmt-vscode"
        "ziglang.vscode-zig"
        "bierner.comment-tagged-templates"
      ];
      "git.openRepositoryInParentFolders" = "never";
      "editor.inlineSuggest.enabled" = true;
      "sourcekit-lsp.serverPath" = "/usr/bin/sourcekit-lsp";
      "lldb.library" = "/Applications/Xcode-15.0.1.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB";
      "github.copilot.enable" = {
        "*" = true;
        "plaintext" = true;
        "markdown" = true;
        "scminput" = false;
        "jsonc" = true;
      };
      "[vue]" = {
        "editor.defaultFormatter" = "octref.vetur";
      };
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "update.showReleaseNotes" = false;
      "lldb.suppressUpdateNotifications" = true;
      "lldb.launch.expressions" = "native";
      "zig.checkForUpdate" = false;
      "zig.path" = "zig";
      "zig.initialSetupDone" = true;
      "window.zoomLevel" = 1;
      "git.enableSmartCommit" = true;
      "zig.zls.checkForUpdate" = false;
      "zig.zls.warnStyle" = true;
      "window.commandCenter" = false;
      "kotlin.languageServer.enabled" = false;
      "kotlin.debugAdapter.enabled" = false;
      "files.associations" = {
        "*.txt" = "plaintext";
      };
      "editor.unicodeHighlight.nonBasicASCII" = false;
      "terminal.integrated.automationProfile.windows" = null;
      "github.copilot.editor.enableAutoCompletions" = true;
      "zig.zls.path" = "zls";
      "workbench.activityBar.location" = "hidden";
      "editor.minimap.enabled" = false;
      "breadcrumbs.enabled" = false;
      "editor.renderWhitespace" = "all";
      "editor.codeActionsOnSave" = {
      };
      "rust-analyzer.debug.engineSettings" = {};
      "yaml.schemas" = {
        "file:///Users/thekorn/.vscode/extensions/atlassian.atlascode-3.0.10/resources/schemas/pipelines-schema.json" = "bitbucket-pipelines.yml";
      };
    };
    #extensions = with pkgs.vscode-extensions; [
    #  dracula-theme.theme-dracula
    #  vscodevim.vim
    #  yzhang.markdown-all-in-one
    #];
  };
}
