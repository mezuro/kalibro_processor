require "rails_helper"

RSpec.describe KalibroModulesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/kalibro_modules").to route_to("kalibro_modules#index")
    end

    it "routes to #new" do
      expect(:get => "/kalibro_modules/new").to_not route_to("kalibro_modules#new")
    end

    it "routes to #exists" do
      expect(:get => "/kalibro_modules/1/exists").to route_to("kalibro_modules#exists", :id => "1")
    end

    it "routes to #show" do
      expect(:get => "/kalibro_modules/1").to route_to("kalibro_modules#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/kalibro_modules/1/edit").to_not route_to("kalibro_modules#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/kalibro_modules").to_not route_to("kalibro_modules#create")
    end

    it "routes to #update" do
      expect(:put => "/kalibro_modules/1").to_not route_to("kalibro_modules#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/kalibro_modules/1").to_not route_to("kalibro_modules#destroy", :id => "1")
    end

    it "routes to #module_results" do
      expect(:get => "/kalibro_modules/1/module_results").to route_to("kalibro_modules#module_results", :id => "1")
    end

  end
end
