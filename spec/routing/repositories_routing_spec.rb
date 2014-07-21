require "rails_helper"

describe RepositoriesController, :type => :routing do
  describe "routing" do
    let (:id) { 1 }
    it { is_expected.to route(:get, "/repositories/#{id}").
                  to(controller: :repositories, action: :show, id: id) }
    it { is_expected.to route(:post, "/repositories").
                  to(controller: :repositories, action: :create) }
    it { is_expected.to route(:put, "/repositories/#{id}").
                  to(controller: :repositories, action: :update, id: id) }
    it { is_expected.to route(:delete, "/repositories/#{id}").
                  to(controller: :repositories, action: :destroy, id: id) }
    it { is_expected.to route(:get, "/repositories/types").
                  to(controller: :repositories, action: :types) }
    it { is_expected.to route(:get, "/repositories/#{id}/process").
                  to(controller: :repositories, action: :process_repository, id: id) }
    it { is_expected.to route(:get, "/repositories/#{id}/cancel_process").
                  to(controller: :repositories, action: :cancel_process, id: id) }
    it { is_expected.to route(:get, "/repositories/#{id}/has_processing").
                  to(controller: :repositories, action: :has_processing, id: id) }
    it { is_expected.to route(:get, "/repositories/#{id}/has_ready_processing").
                  to(controller: :repositories, action: :has_ready_processing, id: id) }
    it { is_expected.to route(:get, "/repositories/#{id}/last_ready_processing").
                  to(controller: :repositories, action: :last_ready_processing, id: id) }
    it { is_expected.to route(:post, "/repositories/#{id}/has_processing/after").
                  to(controller: :repositories, action: :has_processing_in_time, after_or_before: "after", id: id) }
  end
end