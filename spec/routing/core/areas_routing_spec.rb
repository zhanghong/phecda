require "spec_helper"

describe Core::AreasController do
  describe "routing" do

    it "routes to #index" do
      get("/core/areas").should route_to("core/areas#index")
    end

    it "routes to #new" do
      get("/core/areas/new").should route_to("core/areas#new")
    end

    it "routes to #show" do
      get("/core/areas/1").should route_to("core/areas#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/areas/1/edit").should route_to("core/areas#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/areas").should route_to("core/areas#create")
    end

    it "routes to #update" do
      put("/core/areas/1").should route_to("core/areas#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/areas/1").should route_to("core/areas#destroy", :id => "1")
    end

  end
end
