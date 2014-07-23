require "spec_helper"

describe Core::PermissionsController do
  describe "routing" do

    it "routes to #index" do
      get("/core/permissions").should route_to("core/permissions#index")
    end

    it "routes to #new" do
      get("/core/permissions/new").should route_to("core/permissions#new")
    end

    it "routes to #show" do
      get("/core/permissions/1").should route_to("core/permissions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/permissions/1/edit").should route_to("core/permissions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/permissions").should route_to("core/permissions#create")
    end

    it "routes to #update" do
      put("/core/permissions/1").should route_to("core/permissions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/permissions/1").should route_to("core/permissions#destroy", :id => "1")
    end

  end
end
