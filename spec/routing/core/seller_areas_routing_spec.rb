require "spec_helper"

describe Core::SellerAreasController do
  describe "routing" do

    it "routes to #index" do
      get("/core/seller_areas").should route_to("core/seller_areas#index")
    end

    it "routes to #new" do
      get("/core/seller_areas/new").should route_to("core/seller_areas#new")
    end

    it "routes to #show" do
      get("/core/seller_areas/1").should route_to("core/seller_areas#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/seller_areas/1/edit").should route_to("core/seller_areas#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/seller_areas").should route_to("core/seller_areas#create")
    end

    it "routes to #update" do
      put("/core/seller_areas/1").should route_to("core/seller_areas#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/seller_areas/1").should route_to("core/seller_areas#destroy", :id => "1")
    end

  end
end
