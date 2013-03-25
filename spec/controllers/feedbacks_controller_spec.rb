require 'spec_helper'

describe FeedbacksController do

  def valid_attributes
    { content: "Content" }
  end

  let(:contest) { create(:contest, user: user) }
  let(:entry) { create(:entry, user: user) }
  let(:user) { create(:user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Feedback" do
        expect {
          post :create, {:feedback => valid_attributes, contest_id: contest.id, entry_id: entry.id}
        }.to change(Feedback, :count).by(1)
      end

      it "assigns a newly created feedback as @feedback" do
        post :create, {:feedback => valid_attributes, contest_id: contest.id, entry_id: entry.id}
        assigns(:feedback).should be_a(Feedback)
        assigns(:feedback).should be_persisted
      end

      it "redirects to the created feedback" do
        post :create, {:feedback => valid_attributes, contest_id: contest.id, entry_id: entry.id}
        response.should redirect_to(contest_entry_url(contest, entry))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved feedback as @feedback" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        post :create, {:feedback => { "content" => "invalid value" }, contest_id: contest.id, entry_id: entry.id}
        assigns(:feedback).should be_a_new(Feedback)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        post :create, {:feedback => { "content" => "invalid value" }, contest_id: contest.id, entry_id: entry.id}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:feedback) { Feedback.create! valid_attributes.merge(entry: entry, user: user) }
    describe "with valid params" do
      it "updates the requested feedback" do
        # Assuming there are no other feedbacks in the database, this
        # specifies that the Feedback created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Feedback.any_instance.should_receive(:update_attributes).with({ "content" => "1" })
        put :update, {:id => feedback.to_param, :feedback => { "content" => "1" }, contest_id: contest.id, entry_id: entry.id}
      end

      it "assigns the requested feedback as @feedback" do
        put :update, {:id => feedback.to_param, :feedback => valid_attributes, contest_id: contest.id, entry_id: entry.id}
        assigns(:feedback).should eq(feedback)
      end

      it "redirects to the feedback" do
        put :update, {:id => feedback.to_param, :feedback => valid_attributes, contest_id: contest.id, entry_id: entry.id}
        response.should redirect_to(contest_entry_url(contest, entry))
      end
    end

    describe "with invalid params" do
      it "assigns the feedback as @feedback" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        put :update, {:id => feedback.to_param, :feedback => { "content" => "invalid value" }, contest_id: contest.id, entry_id: entry.id}
        assigns(:feedback).should eq(feedback)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        put :update, {:id => feedback.to_param, :feedback => { "content" => "invalid value" }, contest_id: contest.id, entry_id: entry.id}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    let!(:feedback) { Feedback.create! valid_attributes.merge(entry: entry, user: user) }
    it "destroys the requested feedback" do
      expect{
        delete :destroy, {:id => feedback.to_param, contest_id: contest.id, entry_id: entry.id}
      }.to change(Feedback, :count).by(-1)
    end

    it "redirects to the feedbacks list" do
      delete :destroy, {:id => feedback.to_param, contest_id: contest.id, entry_id: entry.id}
      response.should redirect_to(contest_entry_url(contest, entry))
    end
  end

end
