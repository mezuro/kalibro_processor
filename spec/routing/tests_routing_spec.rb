require "rails_helper"

describe TestsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:post, '/tests/clean_database').
                  to(controller: :tests, action: :clean_database) }
  end
end