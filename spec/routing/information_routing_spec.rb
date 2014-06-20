require "rails_helper"

describe InformationController do
  describe "routing" do
    it { is_expected.to route(:get, '/').
                  to(controller: :information, action: :data) }
  end
end