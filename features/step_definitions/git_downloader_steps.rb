When(/^I call the available\? method for git$/) do
  @availability = Downloaders::GitDownloader.available?
end

When(/^I call retrieve! from git with "(.*?)" and "(.*?)" and "(.*)"$/) do |address, directory, branch|
  Downloaders::GitDownloader.retrieve!(address, directory, branch)
end

# receives either default or the custom branch name
Then(/^"(.*?)" should be a git repository at the HEAD of the remote (?:default|"(.*?)") branch$/) do |directory, branch|
  expect(Dir.exists?("#{directory}/.git")).to be_truthy
  git = Git.open(directory)
  branch ||= "master"
  expect(git.object('HEAD').sha).to eq(git.object("#{git.remote.name}/#{branch}").sha)
end


Then(/^"(.+?)" should be a git repository with "(.+?)" as it's remote URL$/) do |directory, remote_url|
  git = Git.open(directory)
  expect(git.remote.url).to eq(remote_url)
end
