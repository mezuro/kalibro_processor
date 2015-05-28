When(/^I call the available\? method for git$/) do
  @availability = Downloaders::GitDownloader.available?
end

# branch is an optional parameter
When(/^I call retrieve! from git with "(.*?)" and "(.*?)"(?: and "(.*)")?$/) do |address, directory, branch|
  Downloaders::GitDownloader.retrieve!(address, directory, branch)
end

# receives either default or the custom branch name
Then(/^"(.*?)" should be a git repository on my (?:default|"(.*?)") branch$/) do |directory, branch|
  expect(Dir.exists?("#{directory}/.git")).to be_truthy
  git = Git.open(directory)
  branch ||= git.branch.name
  expect(git.current_branch).to eq(branch)
end
