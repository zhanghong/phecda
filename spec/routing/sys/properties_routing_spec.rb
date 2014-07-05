require "spec_helper"

describe Sys::PropertiesController do
  describe "routing" do

    it "routes to #index" do
      get("/sys/properties").should route_to("sys/properties#index")
    end

    it "routes to #new" do
      get("/sys/properties/new").should route_to("sys/properties#new")
    end

    it "routes to #show" do
      get("/sys/properties/1").should route_to("sys/properties#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sys/properties/1/edit").should route_to("sys/properties#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sys/properties").should route_to("sys/properties#create")
    end

    it "routes to #update" do
      put("/sys/properties/1").should route_to("sys/properties#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sys/properties/1").should route_to("sys/properties#destroy", :id => "1")
    end

  end
end
