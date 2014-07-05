require "spec_helper"

describe Sys::CategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/sys/categories").should route_to("sys/categories#index")
    end

    it "routes to #new" do
      get("/sys/categories/new").should route_to("sys/categories#new")
    end

    it "routes to #show" do
      get("/sys/categories/1").should route_to("sys/categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sys/categories/1/edit").should route_to("sys/categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sys/categories").should route_to("sys/categories#create")
    end

    it "routes to #update" do
      put("/sys/categories/1").should route_to("sys/categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sys/categories/1").should route_to("sys/categories#destroy", :id => "1")
    end

  end
end
