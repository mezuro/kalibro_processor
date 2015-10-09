Given(/^I have the root ModuleResult of the given processing$/) do
  @processing.reload # The processing instance in memory might not be synced with the database modifications made by a previous processing
  @module_result = @processing.root_module_result
end

Given(/^I have the first MetricResult of the given ModuleResult$/) do
  @metric_result = @module_result.metric_results.first
end

When(/^I request the hotspot metric results for the "(.*?)" module result$/) do |module_name|
  @processing.reload

  module_result = if module_name == 'ROOT'
    @processing.root_module_result
  else
    @processing.module_results.joins(:kalibro_module).references(:kalibro_modules)
      .where('kalibro_modules.long_name': module_name).first
  end
  expect(module_result).not_to be_nil, "expected module result with name '#{module_name}', not found"

  @hotspot_metric_results = module_result.descendant_hotspot_metric_results
    .where(metric_configuration_id: @metric_configuration.id)
end

When(/^I request for the ModuleResult associated with the given MetricResult's id$/) do
  visit(metric_result_module_result_path(@metric_result.id))
end

When(/^I request for the ModuleResult of the MetricResult with id "(.*?)"$/) do |id|
  visit(metric_result_module_result_path(id))
end

Then(/^I should get the following hotspot metric results:$/) do |table|
  table.hashes.each do |row|
    module_name = row['module name']
    line_number = row['line'].to_i

    hotspot_metric_result = @hotspot_metric_results.find do |metric_result|
      metric_result.module_result.kalibro_module.long_name == module_name && metric_result.line_number == line_number
    end

    expect(hotspot_metric_result).to be_a(HotspotMetricResult),
      "expected hotspot metric result with module name '#{module_name}' and line #{line_number}, not found"
  end
end

Then(/^I should get the given ModuleResult json$/) do
  expect(page.body).to eq(@module_result.to_j)
end

Then(/^I should get an error response$/) do
  pending # express the regexp above with the code you wish you had
end
