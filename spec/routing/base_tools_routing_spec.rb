require "rails_helper"

describe BaseToolsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/base_tools').
                  to(controller: :base_tools, action: :all_names) }
  end
end