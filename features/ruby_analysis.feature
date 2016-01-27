Feature: Ruby Analysis
  In order to evaluate my Ruby repositories
  As a regular user
  I should be able to run the whole processing

  @clear_repository @kalibro_configuration_restart
  Scenario: An existing ruby repository with a configuration with Flay (Hotspot Metrics)
    Given I have sample readings
    And I have a sample configuration with the Flay hotspot metric
    And I add the "Flog" native metric to the sample configuration
    And I add the "Saikuro" native metric to the sample configuration
    And I have Noosfero's ruby repository with branch "1.3.2"
    And I have a processing within the sample repository
    When I run for the given repository
    Then the repository code_directory should exist
    And I should have a READY processing for the given repository
    And I should have some ModuleResults
    And the ModuleResults should have HotspotResults for the flay metric
    And the HotspotResults should have other related results indicating the duplication