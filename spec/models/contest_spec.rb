require 'spec_helper'

describe Contest do
  it {should validate_presence_of(:bounty)}
  it {should validate_presence_of(:deadline)}
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:user)}

  describe "after_create" do
    describe "create_bounty" do
      let(:contest) { create(:contest) }
      before do
        Contest.any_instance.should_receive(:create_bounty).and_return(true)
      end
      it "should be called" do
        expect(contest).to be_persisted
      end
    end
  end
end
