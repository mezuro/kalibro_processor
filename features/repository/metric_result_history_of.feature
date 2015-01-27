Feature: Metric Result History Of
  In order to evaluate produce charts
  As a regular user
  I should be able to retrieve the history for a given metric result

  @clear_repository @kalibro_configuration_restart
  Scenario: After processing an existing repository with a kalibro configuration
    Given I have sample readings
    And I have a sample kalibro configuration with native metrics
    And I have a sample repository within the sample project
    And I have a processing within the sample repository
    And I run for the given repository
    When I get the history for the first metric result of the root
    Then I should get a list of pairs date and value
