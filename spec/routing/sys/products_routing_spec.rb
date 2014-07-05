require "spec_helper"

describe Sys::ProductsController do
  describe "routing" do

    it "routes to #index" do
      get("/sys/products").should route_to("sys/products#index")
    end

    it "routes to #new" do
      get("/sys/products/new").should route_to("sys/products#new")
    end

    it "routes to #show" do
      get("/sys/products/1").should route_to("sys/products#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sys/products/1/edit").should route_to("sys/products#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sys/products").should route_to("sys/products#create")
    end

    it "routes to #update" do
      put("/sys/products/1").should route_to("sys/products#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sys/products/1").should route_to("sys/products#destroy", :id => "1")
    end

  end
end
