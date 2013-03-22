require 'spec_helper'

describe ContestFollowingsController do
  let(:user) { create :user }
  let(:contest) { create :contest }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe 'GET index' do
    let!(:contest_followings) { create_list :contest_following, 1, user: user, contest: contest }
    let!(:annonymous_contest_followings) { create_list :contest_following, 1, contest: contest }

    before do
      get :index
    end

    it 'should render template index' do
      response.should render_template 'index'
    end

    it 'should assigns correct context_followings' do
      assigns[:contest_followings].should =~ contest_followings
    end
  end

  describe 'POST create' do
    let(:contest_following) { user.contest_followings.last }
    let(:valid_params) { { :contest_following => { contest_id: contest.id } } }

    context 'invalid contest_following' do
      before do
        post :create, valid_params.merge(contest_following: {})
      end

      it 'should not create new contest_following' do
        contest_following.should be_nil
      end

      it 'should redirect to contests_path with notice' do
        response.should redirect_to contests_path
        flash[:notice].should == "Contest can't be blank"
      end
    end

    context 'valid contest_following' do
      before do
        post :create, valid_params
      end

      it 'should create a new context_following' do
        [:user, :contest].each do |attr|
          contest_following.send(attr).should == send(attr)
        end
      end

      it 'should redirect to contest_following index path' do
        response.should redirect_to contest_followings_path
      end
    end
  end

  describe 'DELETE destroy' do
    let(:contest_following) { create :contest_following, user: user }

    before do
      delete :destroy, id: contest_following.id
    end

    it 'should destroy the record' do
      expect { contest_following.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should redirect to contests_path' do
      response.should redirect_to contests_path
    end
  end
end
