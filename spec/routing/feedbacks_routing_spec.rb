require "spec_helper"

describe FeedbacksController do
  describe "routing" do
    it "routes to #create" do
      post("/contests/1/entries/1/feedbacks").should route_to("feedbacks#create", :contest_id => "1", :entry_id => "1")
    end

    it "routes to #update" do
      put("/contests/1/entries/1/feedbacks/1").should route_to("feedbacks#update", :id => "1", :contest_id => "1", :entry_id => "1")
    end

    it "routes to #destroy" do
      delete("/contests/1/entries/1/feedbacks/1").should route_to("feedbacks#destroy", :id => "1", :contest_id => "1", :entry_id => "1")
    end

  end
end
