require "spec_helper"

describe Core::StockInBillsController do
  describe "routing" do

    it "routes to #index" do
      get("/core/stock_in_bills").should route_to("core/stock_in_bills#index")
    end

    it "routes to #new" do
      get("/core/stock_in_bills/new").should route_to("core/stock_in_bills#new")
    end

    it "routes to #show" do
      get("/core/stock_in_bills/1").should route_to("core/stock_in_bills#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/stock_in_bills/1/edit").should route_to("core/stock_in_bills#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/stock_in_bills").should route_to("core/stock_in_bills#create")
    end

    it "routes to #update" do
      put("/core/stock_in_bills/1").should route_to("core/stock_in_bills#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/stock_in_bills/1").should route_to("core/stock_in_bills#destroy", :id => "1")
    end

  end
end
