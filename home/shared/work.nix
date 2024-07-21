{pkgs, ...}: {
  home.packages = with pkgs; [
    # this would be perfect, however we need a way to satisfy the node version requirement
    # means rush needs to be installed in the respectivve node version
    #nodePackages.rush
    graphviz
    hyperfine
  ];
  home.sessionVariables = {
    #jira
    JIRA_URL = "https://burdaforward.atlassian.net";
    JIRA_NAME = "markus.korn";
    JIRA_DEFAULT_ACTION = "new";

    #bunte monorepo
    BROWSERSLIST_IGNORE_OLD_DATA = 1;
  };
}
