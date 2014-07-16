Feature: Runner run
  In order to evaluate my repositories
  As a regular user
  I should be able to run it through all

  @clear_repository @kalibro_restart
  Scenario: An existing repository with a configuration
    Given I have a sample configuration with native metrics
    And I have a sample repository within the sample project
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should have a Root ModuleResult