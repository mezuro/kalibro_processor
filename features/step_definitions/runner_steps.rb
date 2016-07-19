Given(/^I have a sample kalibro configuration with native metrics$/) do
  @kalibro_configuration = FactoryGirl.create(:kalibro_configuration, id: nil)
  metric_configuration = FactoryGirl.create(:metric_configuration,
                                            {id: nil,
                                             metric: FactoryGirl.build(:loc_metric),
                                             reading_group_id: @reading_group.id,
                                             kalibro_configuration_id: @kalibro_configuration.id})
  range = FactoryGirl.build(:range, {id: nil, reading_id: @reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: metric_configuration.id})
  range.save
  compound_metric_configuration = FactoryGirl.create(:compound_metric_configuration,
                                                     metric: FactoryGirl.build(:compound_metric,
                                                                               script: "return loc() * 2;"),
                                                     reading_group_id: @reading_group.id,
                                                     kalibro_configuration_id: @kalibro_configuration.id)
  compound_range = FactoryGirl.build(:range, {reading_id: @reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: compound_metric_configuration.id})
  compound_range.save
end

Given(/^I have a sample configuration with the (\w+) native metric$/) do |metric|
  metric_configuration_factory = (metric + "_metric_configuration").downcase
  metric_factory = (metric + "_metric").downcase
  @configuration = FactoryGirl.create(:kalibro_configuration, id: nil)
  metric_configuration = FactoryGirl.create(metric_configuration_factory.to_sym,
                                            {id: 4,
                                             metric: FactoryGirl.build(metric_factory.to_sym),
                                             reading_group_id: @reading_group.id,
                                             kalibro_configuration_id: @configuration.id})
  range = FactoryGirl.build(:range, {id: nil, reading_id: @reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: metric_configuration.id})
  range.save
  compound_metric_configuration = FactoryGirl.create(metric_configuration_factory.sub("_", "_compound_").to_sym,
                                                     id: 5,
                                             metric: FactoryGirl.build(("compound_" + metric_factory).to_sym),
                                                     reading_group_id: @reading_group.id,
                                                     kalibro_configuration_id: @configuration.id)
  compound_range = FactoryGirl.build(:range, {id: nil, reading_id: @reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: compound_metric_configuration.id})
  compound_range.save
end

Given(/^I have a sample configuration with the (\w+) hotspot metric$/) do |metric|
  metric_configuration_factory = (metric + "_metric_configuration").downcase
  metric_factory = (metric + "_metric").downcase
  @configuration = FactoryGirl.create(:kalibro_configuration, id: nil)
  metric = FactoryGirl.build(metric_factory.to_sym)
  @metric_configuration = FactoryGirl.create(metric_configuration_factory.to_sym,
                                             metric: metric,
                                             kalibro_configuration_id: @configuration.id)
end

Given(/^I have a sample repository$/) do
  @repository = FactoryGirl.create(:sbking_repository, kalibro_configuration: @kalibro_configuration)
end

Given(/^I have a sample ruby repository$/) do
  @repository = FactoryGirl.create(:ruby_repository, kalibro_configuration: @configuration)
end

Given(/^I have a sample ruby repository within the sample project$/) do
  @repository = FactoryGirl.create(:ruby_repository, :with_project_id, kalibro_configuration: @configuration)
end

Given(/^I have a sample php repository$/) do
  @repository = FactoryGirl.create(:php_repository, :with_project_id, kalibro_configuration: @configuration)
end

Given(/^I have a sample configuration with the (\w+) python native metric$/) do |metric|
  metric_configuration_factory = (metric + "_metric_configuration").downcase
  metric_factory = (metric + "_metric").downcase
  @configuration = FactoryGirl.create(:kalibro_configuration, id: nil)
  metric_configuration = FactoryGirl.create(metric_configuration_factory.to_sym,
                                            {id: 4,
                                             metric: FactoryGirl.build(metric_factory.to_sym),
                                             reading_group_id: @reading_group.id,
                                             kalibro_configuration_id: @configuration.id})
  range = FactoryGirl.build(:range, {id: nil, reading_id: @reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: metric_configuration.id})
  range.save
end

Given(/^I have a sample python repository within the sample project$/) do
  @repository = FactoryGirl.create(:python_repository, kalibro_configuration: @configuration)
end

Given(/^I have a sample repository within the sample project$/) do
  @repository = FactoryGirl.create(:sbking_repository, :with_project_id, kalibro_configuration: @kalibro_configuration)
end

Given(/^I have a processing within the sample repository$/) do
  @processing = FactoryGirl.create(:processing, repository: @repository, state: "PREPARING")
end

Given(/^I have a compound metric with an invalid script$/) do
  invalid_compound_metric_configuration = FactoryGirl.create(:compound_metric_configuration,
                                                             metric: FactoryGirl.build(:compound_metric,
                                                                                       script: "rtrnaqdfwqefwqr213r2145211234ed a = b=2",
                                                                                       code: "ACM"),
                                                             reading_group_id: @reading_group.id,
                                                             kalibro_configuration_id: @kalibro_configuration.id)
  compound_range = FactoryGirl.build(:range, {reading_id: @reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: invalid_compound_metric_configuration.id})
  compound_range.save
end

Given(/^I have sample readings$/) do
  @reading_group = FactoryGirl.create(:reading_group)
  @reading = FactoryGirl.create(:reading, {reading_group_id: @reading_group.id})
end

Given(/^I have a sample kalibro configuration$/) do
  @kalibro_configuration = FactoryGirl.create(:kalibro_configuration, name: "teste")
end

Given(/^I have a range for this metric configuration$/) do
  range = FactoryGirl.build(:range, {reading_id: @reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: @metric_configuration.id})
  range.save
end

Given(/^I add the "(.*?)" analizo metric with scope "(.*?)" and code "(.*?)"$/) do |name, scope, code|
  @metric_configuration = FactoryGirl.create(:metric_configuration,
                                             {metric: FactoryGirl.build(:native_metric, :analizo, name: name, scope: scope, code: code),
                                             reading_group_id: @reading_group.id,
                                             kalibro_configuration_id: @kalibro_configuration.id})
end

Given(/^I have two compound metrics with script "(.*?)" and "(.*?)"$/) do |script1, script2|
  @compound_metric_configuration = FactoryGirl.create(:compound_metric_configuration,
                                                        metric: FactoryGirl.build(:compound_metric, script: script1,
                                                                                   code: "compound_metric"),
                                                                                   reading_group_id: @reading_group.id,
                                                                                   kalibro_configuration_id: @kalibro_configuration.id)
  @other_compound_metric_configuration = FactoryGirl.create(:compound_metric_configuration,
                                                        metric: FactoryGirl.build(:compound_metric, script: script2,
                                                                                   code: "ACM"),
                                                                                   reading_group_id: @reading_group.id,
                                                                                   kalibro_configuration_id: @kalibro_configuration.id)
  compound_range = FactoryGirl.build(:range, {reading_id: @reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: @compound_metric_configuration.id})
  compound_range.save
  other_compound_range = FactoryGirl.build(:range, {reading_id: @reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: @other_compound_metric_configuration.id})
  other_compound_range.save
end

Given(/^I add the "(.*?)" native metric to the sample configuration$/) do |metric|
  metric_configuration_factory = (metric + "_metric_configuration").downcase
  metric_factory = (metric + "_metric").downcase
  metric_configuration = FactoryGirl.create(metric_configuration_factory.to_sym,
                                            {id: 4,
                                             metric: FactoryGirl.build(metric_factory.to_sym),
                                             reading_group_id: @reading_group.id,
                                             kalibro_configuration_id: @configuration.id})
  range = FactoryGirl.build(:range, {id: nil, reading_id: @reading.id, beginning: '-INF', :end => 'INF', metric_configuration_id: metric_configuration.id})
  range.save
end

Given(/^I use the hotspot metric to create a compound metric$/) do
  code = @metric_configuration.metric.code
  @compound = FactoryGirl.create(:compound_metric_configuration,
                                  metric: FactoryGirl.build(:compound_metric, code: "cm", script: "return #{code}() * 2;"),
                                  kalibro_configuration_id: @configuration.id)

end

When(/^I run for the given repository$/) do
  @repository.process(@processing)
  @processing.reload

  if @processing.state == 'READY'
    @processing.process_times(true).each do |process_time|
      puts '%-15s %.4fs' % [process_time.state + ':', process_time.time]
    end
  end
end

When(/^I wait for the "(.*?)" state$/) do |state|
  @processing.reload
  unless @processing.state == state
    while(true)
      if @processing.state == state
        break
      else
        sleep(10)
      end
    end
  end
end

Then(/^the repository code_directory should exist$/) do
  @repository.reload
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

Then(/^the Root ModuleResult retrieved should have a list of MetricResults$/) do
  expect(@processing.root_module_result.metric_results.first).to be_a(TreeMetricResult)
end

Then(/^I should receive a processing error$/) do
  @processing.reload
  expect(@processing.error_message).to_not be_nil
end

Then(/^the processing retrieved should not have any ModuleResults$/) do
  expect(@processing.module_results).to be_empty
end

Then(/^the Root ModuleResult retrieved should not have a MetricResult for the compound metric$/) do
  id1 = @compound_metric_configuration.id
  id2 = @other_compound_metric_configuration.id
  expect(@processing.root_module_result.metric_results.select {
    |metric_result| metric_result.metric_configuration_id == id1 || metric_result.metric_configuration_id == id2 }).to be_empty
end

Then(/^I should have some ModuleResults$/) do
  expect(@processing.module_results).not_to be_empty
end

Then(/^the ModuleResults should have HotspotResults for the (\w+) metric$/) do |metric_code|
  @hotspot_results = @processing.module_results.map { |module_result|
    module_result.hotspot_metric_results
  }.flatten

  expect(@hotspot_results).not_to be_empty

  @hotspot_results.each do |hotspot_result|
    expect(hotspot_result.metric.code).to eq(metric_code)
  end
end

Then(/^the HotspotResults should have other related results indicating the duplication$/) do
  @hotspot_results.each do |hotspot_result|
    expect(hotspot_result.related_results).not_to be_empty
  end
end

Then(/^the Root ModuleResult retrieved should have exactly "(.*?)" MetricResults$/) do |count|
  expect(@processing.root_module_result.metric_results.count).to eq(count.to_i)
end

Then(/^at least one MetricResult should be non\-zero$/) do
  metric_results = @processing.root_module_result.metric_results

  values = metric_results.map { |metric_result| metric_result.value.abs }

  expect(values.reduce(:+)).to_not eq(0)
end

Then(/^the analysis should terminate with an ERROR$/) do
  @processing.reload
  while(true)
    unless @processing.state.ends_with?("ING")
      break
    else
      sleep(2)
    end
  end
  expect(@processing.state).to eq('ERROR')
end

Then(/^the error message should be "(.*?)"$/) do |error_message|
  expect(@processing.error_message).to match(error_message)
end
