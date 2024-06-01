{pkgs, ...}: {
  home.sessionVariables = {
    #jira
    JIRA_URL = "https://burdaforward.atlassian.net";
    JIRA_NAME = "markus.korn";
    JIRA_DEFAULT_ACTION = "new";

    #bunte monorepo
    BROWSERSLIST_IGNORE_OLD_DATA = 1;
  };
}
