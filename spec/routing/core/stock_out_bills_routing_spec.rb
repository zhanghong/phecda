require "spec_helper"

describe Core::StockOutBillsController do
  describe "routing" do

    it "routes to #index" do
      get("/core/stock_out_bills").should route_to("core/stock_out_bills#index")
    end

    it "routes to #new" do
      get("/core/stock_out_bills/new").should route_to("core/stock_out_bills#new")
    end

    it "routes to #show" do
      get("/core/stock_out_bills/1").should route_to("core/stock_out_bills#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/stock_out_bills/1/edit").should route_to("core/stock_out_bills#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/stock_out_bills").should route_to("core/stock_out_bills#create")
    end

    it "routes to #update" do
      put("/core/stock_out_bills/1").should route_to("core/stock_out_bills#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/stock_out_bills/1").should route_to("core/stock_out_bills#destroy", :id => "1")
    end

  end
end
