require "spec_helper"

describe StructuralSetsController do
  describe "routing" do

    it "routes to #index" do
      get("/structural_sets").should route_to("structural_sets#index")
    end

    it "routes to #new" do
      get("/structural_sets/new").should route_to("structural_sets#new")
    end

    it "routes to #show" do
      get("/structural_sets/1").should route_to("structural_sets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/structural_sets/1/edit").should route_to("structural_sets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/structural_sets").should route_to("structural_sets#create")
    end

    it "routes to #update" do
      put("/structural_sets/1").should route_to("structural_sets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/structural_sets/1").should route_to("structural_sets#destroy", :id => "1")
    end

  end
end
