Feature: Runner run
  In order to evaluate my repositories
  As a regular user
  I should be able to run it through all

  @clear_repository @kalibro_configuration_restart
  Scenario: An existing repository with a kalibro configuration
    Given I have sample readings
    And I have a sample kalibro configuration with native metrics
    And I have two compound metrics with script "return 1.0/0.0;" and "return Math.sqrt(-5);"
    And I have a sample repository
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should have a Root ModuleResult
    And the Root ModuleResult retrieved should have a list of MetricResults
    And at least one MetricResult should be non-zero
    And the Root ModuleResult retrieved should not have a MetricResult for the compound metric

  @clear_repository @kalibro_configuration_restart
  Scenario: An existing ruby repository with a configuration with Saikuro and Flog
    Given I have sample readings
    And I have a sample configuration with the Saikuro native metric
    And I add the "Flog" native metric to the sample configuration
    And I have a sample ruby repository
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should have a Root ModuleResult
    And the Root ModuleResult retrieved should have a list of MetricResults

  @clear_repository @kalibro_configuration_restart
  Scenario: A failing processing
    Given I have sample readings
    And I have a sample kalibro configuration with native metrics
    And I have a compound metric with an invalid script
    And I have a sample repository
    And I have a processing within the sample repository
    When I run for the given repository
    Then I should receive a processing error

  @clear_repository @kalibro_configuration_restart
  Scenario: Aggregating some metric values
    Given I have sample readings
    And I have a sample kalibro configuration
    And I add the "Number of Attributes" analizo metric with scope "CLASS" and code "noa"
    And I have a range for this metric configuration
    And I add the "Number of Public Attributes" analizo metric with scope "CLASS" and code "npa"
    And I have a range for this metric configuration
    And I add the "Total Lines of Code" analizo metric with scope "SOFTWARE" and code "total_loc"
    And I have a range for this metric configuration
    And I have a sample repository
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should have a Root ModuleResult
    And the Root ModuleResult retrieved should have exactly "3" MetricResults
    And the Root ModuleResult retrieved should have a list of MetricResults

  @clear_repository @kalibro_configuration_restart
  Scenario: A processing with an empty kalibro configuration
    Given I have a sample kalibro configuration
    And I have a sample repository
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should not have any ModuleResults

  @clear_repository @kalibro_configuration_restart
  Scenario: An existing ruby repository with a configuration with Flay (Hotspot Metrics)
    Given I have a sample configuration with the Flay hotspot metric
    And I have a sample ruby repository
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And I should have some ModuleResults
    And the ModuleResults should have HotspotResults for the flay metric
    And the HotspotResults should have other related results indicating the duplication

  @clear_repository @kalibro_configuration_restart
  Scenario: An existing python repository with a configuration with Cyclomatic Complexity
    Given I have sample readings
    And I have a sample configuration with the Cyclomatic python native metric
    And I add the "Maintainability" native metric to the sample configuration
    And I have a sample python repository within the sample project
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should have a Root ModuleResult
    And the Root ModuleResult retrieved should have a list of MetricResults

  @clear_repository @kalibro_configuration_restart
  Scenario: An existing java repository with a configuration with Analizo
    Given I have sample readings
    And I have a sample kalibro configuration with native metrics
    And I have a sample repository
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And the processing retrieved should have a Root ModuleResult
    And the Root ModuleResult retrieved should have a list of MetricResults

  @clear_repository @kalibro_configuration_restart @docker
  Scenario: An existing php repository with a configuration with PHPMD (Hotspot Metrics)
    Given I have a sample configuration with the PHPMD hotspot metric
    And I have a sample php repository
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And I should have some ModuleResults
    And the ModuleResults should have HotspotResults for the ccvn metric

  @clear_repository @kalibro_configuration_restart
  Scenario: Source code analysis when a compound metric uses a hotspot metric code
    Given I have a sample configuration with the Flay hotspot metric
    And I use the hotspot metric to create a compound metric
    And I have a sample ruby repository
    And I have a processing within the sample repository
    When I run for the given repository
    Then the analysis should terminate with an ERROR
    And the error message should be "Cannot use hotspot metric codes to create compound metrics."
