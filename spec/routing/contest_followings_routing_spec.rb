require "spec_helper"

describe ContestFollowingsController do
  describe "routing" do

    it "routes to #index" do
      get("/contest_followings").should route_to("contest_followings#index")
    end

    it "routes to #create" do
      post("/contest_followings").should route_to("contest_followings#create")
    end

    it "routes to #destroy" do
      delete("/contest_followings/1").should route_to("contest_followings#destroy", :id => "1")
    end

  end
end
