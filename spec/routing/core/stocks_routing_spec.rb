require "spec_helper"

describe Core::StocksController do
  describe "routing" do

    it "routes to #index" do
      get("/core/stocks").should route_to("core/stocks#index")
    end

    it "routes to #new" do
      get("/core/stocks/new").should route_to("core/stocks#new")
    end

    it "routes to #show" do
      get("/core/stocks/1").should route_to("core/stocks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/stocks/1/edit").should route_to("core/stocks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/stocks").should route_to("core/stocks#create")
    end

    it "routes to #update" do
      put("/core/stocks/1").should route_to("core/stocks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/stocks/1").should route_to("core/stocks#destroy", :id => "1")
    end

  end
end
