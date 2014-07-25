Given(/^I have a sample configuration with native metrics$/) do
  reading_group = FactoryGirl.create(:reading_group, id: nil)
  reading = FactoryGirl.create(:reading, {id: nil, group_id: reading_group.id})
  @configuration = FactoryGirl.create(:configuration, id: nil)
  metric_configuration = FactoryGirl.create(:metric_configuration,
                                            {id: nil,
                                             code: 'loc',
                                             metric: FactoryGirl.build(:kalibro_gatekeeper_client_loc),
                                             reading_group_id: reading_group.id,
                                             configuration_id: @configuration.id})
  range = FactoryGirl.build(:range, {id: nil, reading_id: reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: metric_configuration.id})
  range.save
  compound_metric_configuration = FactoryGirl.create(:compound_metric_configuration,
                                                      id: nil,
                                                      code: 'two_loc',
                                                      metric: FactoryGirl.build(:kalibro_gatekeeper_client_compound_metric,
                                                        script: "return loc() * 2;"))
  compound_range = FactoryGirl.build(:range, {id: nil, reading_id: reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: compound_metric_configuration.id})
  compound_range.save
end

Given(/^I have a sample repository within the sample project$/) do
  @repository = FactoryGirl.create(:sbking_repository, configuration: @configuration)
end

Given(/^I have a processing within the sample repository$/) do
  @processing = FactoryGirl.create(:processing, repository: @repository, state: "PREPARING")
end

When(/^I run for the given repository$/) do
  @repository.process(@processing)
end

Then(/^the repository code_directory should exist$/) do
  expect(Dir.exists?(@repository.code_directory)).to be_truthy
end

Then(/^I should have a READY processing for the given repository$/) do
  @processing = @repository.processings.first
  expect(@processing).to be_a(Processing)
  expect(@processing.state).to eq("READY")
end

Then(/^the processing retrieved should have a Root ModuleResult$/) do
  expect(@processing.root_module_result).to be_a(ModuleResult)
end