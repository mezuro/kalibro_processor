require "rails_helper"

describe RepositoriesController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/repositories/1').
                  to(controller: :repositories, action: :show, id: 1) }
    it { is_expected.to route(:post, '/repositories').
                  to(controller: :repositories, action: :create) }
    it { is_expected.to route(:put, '/repositories/1').
                  to(controller: :repositories, action: :update, id: 1) }
    it { is_expected.to route(:delete, '/repositories/1').
                  to(controller: :repositories, action: :destroy, id: 1) }
    it { is_expected.to route(:get, '/repositories/types').
                  to(controller: :repositories, action: :types) }
    it { is_expected.to route(:get, '/repositories/1/process').
                  to(controller: :repositories, action: :process_repository, id: 1) }
    it { is_expected.to route(:get, '/repositories/1/cancel_process').
                  to(controller: :repositories, action: :cancel_process, id: 1) }
  end
end