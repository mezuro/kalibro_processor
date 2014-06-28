Feature: GitDownloader retrieve
  In order to download my repositories
  As a regular user
  I should use the retrieve them

  Scenario: cloning and updating
  When I call retrieve! from git with "/tmp/test" and "https://git.gitorious.org/sbking/sbking.git"
  Then "/tmp/test" should be a git repository
  When I call retrieve! from git with "/tmp/test" and "https://git.gitorious.org/sbking/sbking.git"
  Then "/tmp/test" should be a git repository