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
