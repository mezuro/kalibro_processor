Feature: GitDownloader retrieve
  In order to download my repositories
  As a regular user
  I should be able to retrieve them

  @clear_test_dir @wip
  Scenario: cloning and updating
  When I call retrieve! from git with "https://github.com/mezuro/kalibro_client" and "/tmp/test"
  Then "/tmp/test" should be a git repository on my default branch
  When I call retrieve! from git with "https://github.com/mezuro/kalibro_client" and "/tmp/test"
  Then "/tmp/test" should be a git repository on my default branch
  When I call retrieve! from git with "https://github.com/mezuro/kalibro_client" and "/tmp/test" and "stable"
  Then "/tmp/test" should be a git repository on my "stable" branch
  When I call retrieve! from git with "https://github.com/mezuro/kalibro_client" and "/tmp/test" and "stable"
  Then "/tmp/test" should be a git repository on my "stable" branch
