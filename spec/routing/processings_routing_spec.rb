require "rails_helper"

describe ProcessingsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/processings/1/process_times').
                  to(controller: :processings, action: :process_times, id: 1) }
    it { is_expected.to route(:get, '/processings/1/error_message').
                  to(controller: :processings, action: :error_message, id: 1) }
    it { is_expected.to route(:get, '/processings/1').
                  to(controller: :processings, action: :show, id: 1) }
    it { is_expected.to route(:get, '/processings/1/exists').
                  to(controller: :processings, action: :exists, id: 1) }
  end
end
