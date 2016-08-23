require "rails_helper"

describe InformationController do
  before { skip "Updating to rails 5" }
  describe "routing" do
    it { is_expected.to route(:get, '/').
                  to(controller: :information, action: :data) }
  end
end
