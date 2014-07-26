require "spec_helper"

describe Core::LogisticAreasController do
  describe "routing" do

    it "routes to #index" do
      get("/core/logistic_areas").should route_to("core/logistic_areas#index")
    end

    it "routes to #new" do
      get("/core/logistic_areas/new").should route_to("core/logistic_areas#new")
    end

    it "routes to #show" do
      get("/core/logistic_areas/1").should route_to("core/logistic_areas#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/logistic_areas/1/edit").should route_to("core/logistic_areas#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/logistic_areas").should route_to("core/logistic_areas#create")
    end

    it "routes to #update" do
      put("/core/logistic_areas/1").should route_to("core/logistic_areas#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/logistic_areas/1").should route_to("core/logistic_areas#destroy", :id => "1")
    end

  end
end
