require "rails_helper"

RSpec.describe ProcessTimesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/process_times").to route_to("process_times#index")
    end

    it "routes to #new" do
      expect(:get => "/process_times/new").to_not route_to("process_times#new")
    end

    it "routes to #show" do
      expect(:get => "/process_times/1").to route_to("process_times#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/process_times/1/edit").to_not route_to("process_times#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/process_times").to_not route_to("process_times#create")
    end

    it "routes to #update" do
      expect(:put => "/process_times/1").to_not route_to("process_times#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/process_times/1").to_not route_to("process_times#destroy", :id => "1")
    end

    it "routes to #processing" do
      expect(:get => "/process_times/1/processing").to route_to("process_times#processing", :id => "1")
    end

  end
end
