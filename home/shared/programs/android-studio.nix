{pkgs, ...}: {
  home.sessionVariables = {ANDROID_HOME = "$HOME/Library/Android/sdk";};
  home.sessionPath = [
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/cmdline-tools/latest/bin"
    "$ANDROID_HOME/tools"
    "$ANDROID_HOME/tools/bin"
    "$ANDROID_HOME/platform-tools"
  ];
}
