When(/^I get the history for the first metric result of the root$/) do
  root_module_result = @repository.processings.first.root_module_result

  metric_name = root_module_result.metric_results.first.metric.name
  module_name = root_module_result.kalibro_module.long_name

  @history = @repository.metric_result_history_of(module_name, metric_name)
end

Then(/^I should get a list of pairs date and value$/) do
  expect(@history.first[:date]).to be_a(ActiveSupport::TimeWithZone)
  expect(@history.first[:metric_result]).to be_a(TreeMetricResult)
end