Given(/^I have the kalibro processor ruby repository with revision "(.+)"$/)do |tag|
  @repository = FactoryGirl.create(:repository, :kalibro_processor, branch: tag, kalibro_configuration: @configuration)
end

Given(/^I have Noosfero's ruby repository with branch "(.+)"$/)do |tag|
  @repository = FactoryGirl.create(:repository, :noosfero, branch: tag, kalibro_configuration: @configuration)
end
