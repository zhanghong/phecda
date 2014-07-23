require "spec_helper"

describe Core::RolesController do
  describe "routing" do

    it "routes to #index" do
      get("/core/roles").should route_to("core/roles#index")
    end

    it "routes to #new" do
      get("/core/roles/new").should route_to("core/roles#new")
    end

    it "routes to #show" do
      get("/core/roles/1").should route_to("core/roles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/roles/1/edit").should route_to("core/roles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/roles").should route_to("core/roles#create")
    end

    it "routes to #update" do
      put("/core/roles/1").should route_to("core/roles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/roles/1").should route_to("core/roles#destroy", :id => "1")
    end

  end
end
