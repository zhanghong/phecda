require "spec_helper"

describe Core::UserRolesController do
  describe "routing" do

    it "routes to #index" do
      get("/core/user_roles").should route_to("core/user_roles#index")
    end

    it "routes to #new" do
      get("/core/user_roles/new").should route_to("core/user_roles#new")
    end

    it "routes to #show" do
      get("/core/user_roles/1").should route_to("core/user_roles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/user_roles/1/edit").should route_to("core/user_roles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/user_roles").should route_to("core/user_roles#create")
    end

    it "routes to #update" do
      put("/core/user_roles/1").should route_to("core/user_roles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/user_roles/1").should route_to("core/user_roles#destroy", :id => "1")
    end

  end
end
