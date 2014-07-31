require "rails_helper"

describe ProcessingsController, :type => :routing do
  describe "routing" do
    it { is_expected.to route(:get, '/processings/1/process_times').
                  to(controller: :processings, action: :process_times, id: 1) }
  end
end