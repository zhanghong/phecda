require "spec_helper"

describe Core::LogisticsController do
  describe "routing" do

    it "routes to #index" do
      get("/core/logistics").should route_to("core/logistics#index")
    end

    it "routes to #new" do
      get("/core/logistics/new").should route_to("core/logistics#new")
    end

    it "routes to #show" do
      get("/core/logistics/1").should route_to("core/logistics#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/logistics/1/edit").should route_to("core/logistics#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/logistics").should route_to("core/logistics#create")
    end

    it "routes to #update" do
      put("/core/logistics/1").should route_to("core/logistics#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/logistics/1").should route_to("core/logistics#destroy", :id => "1")
    end

  end
end
