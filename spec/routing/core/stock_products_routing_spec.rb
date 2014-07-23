require "spec_helper"

describe Core::StockProductsController do
  describe "routing" do

    it "routes to #index" do
      get("/core/stock_products").should route_to("core/stock_products#index")
    end

    it "routes to #new" do
      get("/core/stock_products/new").should route_to("core/stock_products#new")
    end

    it "routes to #show" do
      get("/core/stock_products/1").should route_to("core/stock_products#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/stock_products/1/edit").should route_to("core/stock_products#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/stock_products").should route_to("core/stock_products#create")
    end

    it "routes to #update" do
      put("/core/stock_products/1").should route_to("core/stock_products#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/stock_products/1").should route_to("core/stock_products#destroy", :id => "1")
    end

  end
end
