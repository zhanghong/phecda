require "spec_helper"

describe Edm::TasksController do
  describe "routing" do

    it "routes to #index" do
      get("/edm/tasks").should route_to("edm/tasks#index")
    end

    it "routes to #new" do
      get("/edm/tasks/new").should route_to("edm/tasks#new")
    end

    it "routes to #show" do
      get("/edm/tasks/1").should route_to("edm/tasks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/edm/tasks/1/edit").should route_to("edm/tasks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/edm/tasks").should route_to("edm/tasks#create")
    end

    it "routes to #update" do
      put("/edm/tasks/1").should route_to("edm/tasks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/edm/tasks/1").should route_to("edm/tasks#destroy", :id => "1")
    end

  end
end
