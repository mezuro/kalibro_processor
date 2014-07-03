When(/^I call the available\? method for git$/) do
  @availability = Downloaders::GitDownloader.available?
end

When(/^I call retrieve! from git with "(.*?)" and "(.*?)"$/) do |address, directory|
  Downloaders::GitDownloader.retrieve!(address, directory)
end

Then(/^"(.*?)" should be a git repository$/) do |directory|
  expect(Dir.exists?("#{directory}/.git")).to be_truthy
end
