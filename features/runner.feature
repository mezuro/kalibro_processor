Feature: Runner run
  In order to evaluate my repositories
  As a regular user
  I should be able to run it through all

  @clear_repository @kalibro_restart
  Scenario: An existing repository with a configuration
    Given I have a sample configuration with native metrics
    And I have a sample repository within the sample project
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should have a Root ModuleResult
    And the Root ModuleResult retrieved should have a list of MetricResults

  @clear_repository @kalibro_restart
  Scenario: A failing processing
    Given I have a sample configuration with native metrics
    And I have a compound metric with an invalid script
    And I have a sample repository within the sample project
    And I have a processing within the sample repository
    When I run for the given repository
    Then I should receive a processing error
