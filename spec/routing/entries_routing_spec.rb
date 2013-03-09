require "spec_helper"

describe EntriesController do
  describe "routing" do

    it "routes to #index" do
      get("/contests/1/entries").should route_to("entries#index", :contest_id => "1")
    end

    it "routes to #new" do
      get("/contests/1/entries/new").should route_to("entries#new", :contest_id => "1")
    end

    it "routes to #show" do
      get("/contests/1/entries/1").should route_to("entries#show", :contest_id => "1", :id => "1")
    end

    it "routes to #edit" do
      get("/contests/1/entries/1/edit").should route_to("entries#edit", :contest_id => "1", :id => "1")
    end

    it "routes to #create" do
      post("/contests/1/entries").should route_to("entries#create", :contest_id => "1")
    end

    it "routes to #update" do
      put("/contests/1/entries/1").should route_to("entries#update", :contest_id => "1", :id => "1")
    end

    it "routes to #destroy" do
      delete("/contests/1/entries/1").should route_to("entries#destroy", :contest_id => "1", :id => "1")
    end

  end
end
