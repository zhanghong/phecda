require "spec_helper"

describe Sys::SkusController do
  describe "routing" do

    it "routes to #index" do
      get("/sys/skus").should route_to("sys/skus#index")
    end

    it "routes to #new" do
      get("/sys/skus/new").should route_to("sys/skus#new")
    end

    it "routes to #show" do
      get("/sys/skus/1").should route_to("sys/skus#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sys/skus/1/edit").should route_to("sys/skus#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sys/skus").should route_to("sys/skus#create")
    end

    it "routes to #update" do
      put("/sys/skus/1").should route_to("sys/skus#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sys/skus/1").should route_to("sys/skus#destroy", :id => "1")
    end

  end
end
