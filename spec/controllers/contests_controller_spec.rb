require 'spec_helper'

describe ContestsController do

  let(:valid_attributes) do
    valid_form_attributes.merge(user: user)
  end

  let(:valid_form_attributes) do
    {
      bounty: 10,
      deadline: Time.now,
      description: "abc",
      name: "Name"
    }
  end

  let!(:user) { create(:user) }

  let(:valid_session) { {} }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET index" do
    it "assigns all contests as @contests" do
      contest = Contest.create! valid_attributes
      get :index, {}
      assigns(:contests).should eq([contest])
    end
  end

  describe "GET show" do
    it "assigns the requested contest as @contest" do
      contest = Contest.create! valid_attributes
      get :show, {:id => contest.id}
      assigns(:contest).should eq(contest)
    end
  end

  describe "GET new" do
    it "assigns a new contest as @contest" do
      get :new, {}
      assigns(:contest).should be_a_new(Contest)
    end
  end

  describe "GET edit" do
    it "assigns the requested contest as @contest" do
      contest = Contest.create! valid_attributes
      get :edit, {:id => contest.id}
      assigns(:contest).should eq(contest)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Contest" do
        expect {
          post :create, {:contest => valid_form_attributes}
        }.to change(Contest, :count).by(1)
      end

      it "assigns a newly created contest as @contest" do
        post :create, {:contest => valid_form_attributes}
        assigns(:contest).should be_a(Contest)
        assigns(:contest).should be_persisted
      end

      it "redirects to the created contest" do
        post :create, {:contest => valid_form_attributes}
        response.should redirect_to(Contest.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contest as @contest" do
        # Trigger the behavior that occurs when invalid params are submitted
        Contest.any_instance.stub(:save).and_return(false)
        post :create, {:contest => valid_form_attributes}
        assigns(:contest).should be_a_new(Contest)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Contest.any_instance.stub(:save).and_return(false)
        post :create, {:contest => valid_form_attributes}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested contest" do
        contest = Contest.create! valid_attributes
        # Assuming there are no other contests in the database, this
        # specifies that the Contest created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Contest.any_instance.should_receive(:update_attributes).with({ "description" => "1" })
        put :update, {:id => contest.to_param, :contest => { "description" => "1" }}
      end

      it "assigns the requested contest as @contest" do
        contest = Contest.create! valid_attributes
        put :update, {:id => contest.to_param, :contest => valid_form_attributes}
        assigns(:contest).should eq(contest)
      end

      it "redirects to the contest" do
        contest = Contest.create! valid_attributes
        put :update, {:id => contest.to_param, :contest => valid_form_attributes}
        response.should redirect_to(contest)
      end
    end

    describe "with invalid params" do
      it "assigns the contest as @contest" do
        contest = Contest.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Contest.any_instance.stub(:save).and_return(false)
        put :update, {:id => contest.to_param, :contest => { "description" => "invalid value" }}
        assigns(:contest).should eq(contest)
      end

      it "re-renders the 'edit' template" do
        contest = Contest.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Contest.any_instance.stub(:save).and_return(false)
        put :update, {:id => contest.to_param, :contest => { "description" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested contest" do
      contest = Contest.create! valid_attributes
      expect {
        delete :destroy, {:id => contest.to_param}
      }.to change(Contest, :count).by(-1)
    end

    it "redirects to the contests list" do
      contest = Contest.create! valid_attributes
      delete :destroy, {:id => contest.to_param}
      response.should redirect_to(contests_url)
    end
  end

end
