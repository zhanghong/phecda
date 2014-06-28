require "spec_helper"

describe Tb::SkusController do
  describe "routing" do

    it "routes to #index" do
      get("/tb/skus").should route_to("tb/skus#index")
    end

    it "routes to #new" do
      get("/tb/skus/new").should route_to("tb/skus#new")
    end

    it "routes to #show" do
      get("/tb/skus/1").should route_to("tb/skus#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tb/skus/1/edit").should route_to("tb/skus#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tb/skus").should route_to("tb/skus#create")
    end

    it "routes to #update" do
      put("/tb/skus/1").should route_to("tb/skus#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tb/skus/1").should route_to("tb/skus#destroy", :id => "1")
    end

  end
end
