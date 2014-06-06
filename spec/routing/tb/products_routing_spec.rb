require "spec_helper"

describe Tb::ProductsController do
  describe "routing" do

    it "routes to #index" do
      get("/tb/products").should route_to("tb/products#index")
    end

    it "routes to #new" do
      get("/tb/products/new").should route_to("tb/products#new")
    end

    it "routes to #show" do
      get("/tb/products/1").should route_to("tb/products#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tb/products/1/edit").should route_to("tb/products#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tb/products").should route_to("tb/products#create")
    end

    it "routes to #update" do
      put("/tb/products/1").should route_to("tb/products#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tb/products/1").should route_to("tb/products#destroy", :id => "1")
    end

  end
end
