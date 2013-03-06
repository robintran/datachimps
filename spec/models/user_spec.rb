require 'spec_helper'

describe User do
  describe '#find_for_facebook_oauth' do
    let(:provider) { "facebook" }
    let(:uid) { "123456" }
    let(:email) { "test@example.com" }
    let(:name) { "Test" }
    let(:auth_info) do
      OpenStruct.new(
        provider: provider,
        uid: uid,
        info: OpenStruct.new(email: email),
        extra: OpenStruct.new(
          raw_info: OpenStruct.new(name: name)
        )
      )
    end

    let(:result) { User.find_for_facebook_oauth(auth_info) }

    describe 'with user existed' do
      let!(:user) { create(:user, uid: uid, provider: provider) }
      it "should find and return that user" do
        lambda do
          result.should == user
        end.should_not change(User, :count)
      end
    end

    describe 'without user existed' do
      it "should create new user with info" do
        lambda do
          user = result
          user.email.should == email
          user.uid.should == uid
          user.provider.should == provider
          user.name.should == name
        end.should change(User, :count).by(1)
      end
    end
  end
end
