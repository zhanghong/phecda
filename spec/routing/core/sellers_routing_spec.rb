require "spec_helper"

describe Core::SellersController do
  describe "routing" do

    it "routes to #index" do
      get("/core/sellers").should route_to("core/sellers#index")
    end

    it "routes to #new" do
      get("/core/sellers/new").should route_to("core/sellers#new")
    end

    it "routes to #show" do
      get("/core/sellers/1").should route_to("core/sellers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/sellers/1/edit").should route_to("core/sellers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/sellers").should route_to("core/sellers#create")
    end

    it "routes to #update" do
      put("/core/sellers/1").should route_to("core/sellers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/sellers/1").should route_to("core/sellers#destroy", :id => "1")
    end

  end
end
