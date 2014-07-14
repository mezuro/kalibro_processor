require "rails_helper"

describe BaseToolsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/base_tools').
                  to(controller: :base_tools, action: :all_names) }
    it { is_expected.to route(:get, '/base_tools/Analizo/find').
                  to(controller: :base_tools, action: :find, id: "Analizo") }
  end
end