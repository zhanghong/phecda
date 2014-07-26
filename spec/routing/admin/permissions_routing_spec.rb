require "spec_helper"

describe Admin::PermissionsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/permissions").should route_to("admin/permissions#index")
    end

    it "routes to #new" do
      get("/admin/permissions/new").should route_to("admin/permissions#new")
    end

    it "routes to #show" do
      get("/admin/permissions/1").should route_to("admin/permissions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/permissions/1/edit").should route_to("admin/permissions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/permissions").should route_to("admin/permissions#create")
    end

    it "routes to #update" do
      put("/admin/permissions/1").should route_to("admin/permissions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/permissions/1").should route_to("admin/permissions#destroy", :id => "1")
    end

  end
end
