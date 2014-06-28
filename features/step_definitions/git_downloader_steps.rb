When(/^I call the available\? method for git$/) do
  @availability = Downloaders::GitDownloader.available?
end

When(/^I call retrieve! from git with "(.*?)" and "(.*?)"$/) do |directory, address|
  Downloaders::GitDownloader.retrieve!(address, directory)
end

Then(/^"(.*?)" should be a git repository$/) do |directory|
  expect(Dir.exists?("#{directory}/.git")).to be_truthy
end

Then(/^I should receive true as availability$/) do
  expect(@availability).to be_truthy
end