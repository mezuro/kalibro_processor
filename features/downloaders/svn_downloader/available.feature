Feature: SvnDownloader available
  In order to download my svn repositories
  As a regular user
  I should be able to check if svn is available

  @clear_test_dir
  Scenario: svn is installed
  When I call the available? method for svn
  Then I should receive true as availability