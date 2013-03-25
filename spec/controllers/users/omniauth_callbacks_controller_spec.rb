require 'spec_helper'

describe Users::OmniauthCallbacksController do
  describe '#facebook' do
    before do
      User.should_receive(:find_for_facebook_oauth).and_return(mock_user)
      request.env["devise.mapping"] = Devise.mappings[:user]
      get :facebook
    end

    describe 'can create new user' do
      let(:mock_user) { create(:user) }

      it "should find and sign user in" do
        response.should redirect_to(root_path)
        controller.current_user.should == mock_user
      end
    end

    describe 'cannot create new user' do
      let(:mock_user) { build(:user) }

      it "should redirect to registration form" do
        response.should redirect_to(new_user_registration_url)
      end
    end
  end
end
