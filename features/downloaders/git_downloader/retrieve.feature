Feature: GitDownloader retrieve
  In order to download my repositories
  As a regular user
  I should be able to retrieve them

  @clear_test_dir
  Scenario: cloning and updating
    When I call retrieve! from git with "https://github.com/mezuro/kalibro_client" and "/tmp/test" and "master"
    Then "/tmp/test" should be a git repository at the HEAD of the remote default branch
    When I call retrieve! from git with "https://github.com/mezuro/kalibro_client" and "/tmp/test" and "master"
    Then "/tmp/test" should be a git repository at the HEAD of the remote default branch
    When I call retrieve! from git with "https://github.com/mezuro/kalibro_client" and "/tmp/test" and "stable"
    Then "/tmp/test" should be a git repository at the HEAD of the remote "stable" branch
    When I call retrieve! from git with "https://github.com/mezuro/kalibro_client" and "/tmp/test" and "stable"
    Then "/tmp/test" should be a git repository at the HEAD of the remote "stable" branch

  @clear_test_dir
  Scenario: updating after changing URL
    When I call retrieve! from git with "https://github.com/mezuro/kalibro_client" and "/tmp/test" and "master"
    Then "/tmp/test" should be a git repository at the HEAD of the remote default branch
    When I call retrieve! from git with "git://github.com/mezuro/kalibro_client.git" and "/tmp/test" and "master"
    Then "/tmp/test" should be a git repository with "git://github.com/mezuro/kalibro_client.git" as it's remote URL
