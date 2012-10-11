require "spec_helper"

describe GenericContentsController do
  describe "routing" do

    it "routes to #index" do
      get("/generic_contents").should route_to("generic_contents#index")
    end

    it "routes to #new" do
      get("/generic_contents/new").should route_to("generic_contents#new")
    end

    it "routes to #show" do
      get("/generic_contents/1").should route_to("generic_contents#show", :id => "1")
    end

    it "routes to #edit" do
      get("/generic_contents/1/edit").should route_to("generic_contents#edit", :id => "1")
    end

    it "routes to #create" do
      post("/generic_contents").should route_to("generic_contents#create")
    end

    it "routes to #update" do
      put("/generic_contents/1").should route_to("generic_contents#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/generic_contents/1").should route_to("generic_contents#destroy", :id => "1")
    end

  end
end
