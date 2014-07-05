require "spec_helper"

describe SkuBindingsController do
  describe "routing" do

    it "routes to #index" do
      get("/sku_bindings").should route_to("sku_bindings#index")
    end

    it "routes to #new" do
      get("/sku_bindings/new").should route_to("sku_bindings#new")
    end

    it "routes to #show" do
      get("/sku_bindings/1").should route_to("sku_bindings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sku_bindings/1/edit").should route_to("sku_bindings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sku_bindings").should route_to("sku_bindings#create")
    end

    it "routes to #update" do
      put("/sku_bindings/1").should route_to("sku_bindings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sku_bindings/1").should route_to("sku_bindings#destroy", :id => "1")
    end

  end
end
