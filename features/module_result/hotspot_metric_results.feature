Feature: Module Result Hotspot Metric Results
  In order to traverse the Hotspot Metric Results for a processing
  As a regular user
  I should be able to get the Hotspot Metric Results of a given Module Result

  @clear_repository @kalibro_configuration_restart
  Scenario: A READY processing with results for the Flay metric
    Given I have a sample configuration with the Flay hotspot metric
    And I have the kalibro processor ruby repository with revision "v0.11.0"
    And I have a processing within the sample repository
    And I run for the given repository
    When I request the hotspot metric results for the "ROOT" module result
    Then I should get the following hotspot metric results:
      | module name                                       | line |
      | lib.metric_collector.native.metric_fu.parser.base | 27   |
      | lib.metric_collector.native.radon.parser.base     | 23   |
      | app.controllers.projects_controller               | 18   |
      | app.controllers.repositories_controller           | 29   |
    When I request the hotspot metric results for the "lib" module result
    Then I should get the following hotspot metric results:
      | module name                                       | line |
      | lib.metric_collector.native.metric_fu.parser.base | 27   |
      | lib.metric_collector.native.radon.parser.base     | 23   |
