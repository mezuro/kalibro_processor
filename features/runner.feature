Feature: Runner run
  In order to evaluate my repositories
  As a regular user
  I should be able to run it through all

  @clear_repository @kalibro_restart
  Scenario: An existing repository with a configuration
    Given I have sample readings
    And I have a sample configuration with native metrics
    And I have a sample repository within the sample project
    And I have a processing within the sample repository
    When I run for the given repository
    And I wait for the "READY" state
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should have a Root ModuleResult
    And the Root ModuleResult retrieved should have a list of MetricResults

  @clear_repository @kalibro_restart
  Scenario: A failing processing
    Given I have sample readings
    And I have a sample configuration with native metrics
    And I have a compound metric with an invalid script
    And I have a sample repository within the sample project
    And I have a processing within the sample repository
    When I run for the given repository
    And I wait for the "ERROR" state
    Then I should receive a processing error

  @clear_repository @kalibro_restart
  Scenario: Aggregating some metric values
    Given I have sample readings
    And I have a sample configuration
    And I add the "Number of Attributes" analizo metric with scope "CLASS" and code "noa"
    And I have a range for this metric configuration
    And I add the "Number of Public Attributes" analizo metric with scope "CLASS" and code "npa"
    And I have a range for this metric configuration
    And I add the "Total Lines of Code" analizo metric with scope "SOFTWARE" and code "total_loc"
    And I have a range for this metric configuration
    And I have a sample repository within the sample project
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should have a Root ModuleResult
    And the Root ModuleResult retrieved should have a list of MetricResults

  @clear_repository @kalibro_restart
  Scenario: A processing with an empty configuration
    Given I have a sample configuration
    And I have a sample repository within the sample project
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should not have any ModuleResults