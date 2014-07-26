require "spec_helper"

describe Core::AccountPermissionsController do
  describe "routing" do

    it "routes to #index" do
      get("/core/account_permissions").should route_to("core/account_permissions#index")
    end

    it "routes to #new" do
      get("/core/account_permissions/new").should route_to("core/account_permissions#new")
    end

    it "routes to #show" do
      get("/core/account_permissions/1").should route_to("core/account_permissions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/account_permissions/1/edit").should route_to("core/account_permissions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/account_permissions").should route_to("core/account_permissions#create")
    end

    it "routes to #update" do
      put("/core/account_permissions/1").should route_to("core/account_permissions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/account_permissions/1").should route_to("core/account_permissions#destroy", :id => "1")
    end

  end
end
