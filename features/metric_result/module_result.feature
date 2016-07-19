Feature: ModuleResult retrieval
  In order to retrive the module result associated to a given MetricResult
  As a kalibro_client developer
  I should be able to make a request that returns the ModuleResult of a given MetricResult id

  @clear_repository @kalibro_configuration_restart
  Scenario: With a valid MetricResult id
    Given I have sample readings
    And I have a sample configuration with the Flay hotspot metric
    And I have the kalibro processor ruby repository with revision "v0.11.0"
    And I have a processing within the sample repository
    And I run for the given repository
    And I have a hotspot MetricResult descendant of the root ModuleResult
    When I request for the ModuleResult associated with the given MetricResult's id
    Then I should get the given ModuleResult json

  Scenario: With an invalid MetricResult id
    When I request for the ModuleResult of the MetricResult with id "42"
    Then I should get an error response
