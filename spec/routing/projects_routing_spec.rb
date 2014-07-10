require "rails_helper"

describe ProjectsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/projects/1').
                  to(controller: :projects, action: :get, id: 1) }
    it { is_expected.to route(:get, '/projects/1/exists').
                  to(controller: :projects, action: :exists, id: 1) }
    it { is_expected.to route(:put, '/projects').
                  to(controller: :projects, action: :save) }
    it { is_expected.to route(:delete, '/projects/1').
                  to(controller: :projects, action: :delete, id: 1) }
    it { is_expected.to route(:get, '/projects').
                  to(controller: :projects, action: :all) }
  end
end