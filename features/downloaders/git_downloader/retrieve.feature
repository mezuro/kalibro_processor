Feature: GitDownloader retrieve
  In order to download my repositories
  As a regular user
  I should be able to retrieve them

  Scenario: cloning and updating
  When I call retrieve! from git with "https://github.com/rafamanzo/runge-kutta-vtk.git" and "/tmp/test"
  Then "/tmp/test" should be a git repository
  When I call retrieve! from git with "https://github.com/rafamanzo/runge-kutta-vtk.git" and "/tmp/test"
  Then "/tmp/test" should be a git repository