require "rails_helper"

describe ProjectsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/projects/1').
                  to(controller: :projects, action: :show, id: 1) }
    it { is_expected.to route(:get, '/projects/1/exists').
                  to(controller: :projects, action: :exists, id: 1) }
    it { is_expected.to route(:get, '/projects/1/repositories').
                  to(controller: :projects, action: :repositories_of, id: 1) }
    it { is_expected.to route(:post, '/projects').
                  to(controller: :projects, action: :create) }
    it { is_expected.to route(:put, '/projects/1').
                  to(controller: :projects, action: :update, id: 1) }
    it { is_expected.to route(:delete, '/projects/1').
                  to(controller: :projects, action: :destroy, id: 1) }
    it { is_expected.to route(:get, '/projects').
                  to(controller: :projects, action: :all) }
  end
end