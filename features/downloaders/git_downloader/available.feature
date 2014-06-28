Feature: GitDownloader available
  In order to download my repositories
  As a regular user
  I should be able to check if git is available

  @clear_test_dir
  Scenario: git is installed
  When I call the available? method for git
  Then I should receive true as availability