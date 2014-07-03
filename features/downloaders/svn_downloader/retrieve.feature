Feature: SvnDownloader retrieve
  In order to download my repositories
  As a regular user
  I should be able to retrieve them

  Scenario: cloning and updating
  When I call retrieve! from svn with "svn://svn.code.sf.net/p/qt-calculator/code/trunk" and "/tmp/test"
  Then "/tmp/test" should be a svn repository
  When I call retrieve! from svn with "svn://svn.code.sf.net/p/qt-calculator/code/trunk" and "/tmp/test"
  Then "/tmp/test" should be a svn repository
