require "spec_helper"

describe Admin::AccountPermissionsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/account_permissions").should route_to("admin/account_permissions#index")
    end

    it "routes to #new" do
      get("/admin/account_permissions/new").should route_to("admin/account_permissions#new")
    end

    it "routes to #show" do
      get("/admin/account_permissions/1").should route_to("admin/account_permissions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/account_permissions/1/edit").should route_to("admin/account_permissions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/account_permissions").should route_to("admin/account_permissions#create")
    end

    it "routes to #update" do
      put("/admin/account_permissions/1").should route_to("admin/account_permissions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/account_permissions/1").should route_to("admin/account_permissions#destroy", :id => "1")
    end

  end
end
