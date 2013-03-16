require 'spec_helper'

describe Contest do
  let(:contest) { build(:contest) }

  it {should validate_presence_of(:bounty)}
  it {should validate_presence_of(:deadline)}
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:user)}

  describe "on_create" do
    before { Contest.any_instance.unstub(:owner_has_account) }

    describe "#owner_has_account?" do
      context "create" do
        it "should be called" do
          contest.should_receive(:owner_has_account).and_return true
          contest.save
        end

        it "add error message when 'balanced_account_uri' is blank" do
          contest.user.stub(:balanced_account_uri).and_return nil
          contest.save
          contest.should_not be_valid
          contest.errors.messages[:base].should == ["Owner must have an account to create a new contest."]
        end
      end

      context "update" do
        it "should not be called" do
          contest.save
          contest.should_not_receive(:owner_has_account)
          contest.update_attributes(:name => 'New name')
        end
      end
    end
  end


  describe "after_create" do
    describe "#create_bounty" do
      before { Contest.any_instance.unstub(:create_bounty) }
      after { contest.save }

      it "should be called" do
        contest.should_receive(:create_bounty).and_return(true)
      end

      it "charge user" do
        contest.user.should_receive(:charge).with(contest.bounty)
      end
    end

    describe "#follow_contest" do
      after { contest.save }

      it "should be called" do
        contest.should_receive(:follow_contest)
      end

      it "allow owner to follow contest" do
        contest.user.should_receive(:follow).with(contest)
      end
    end
  end

  describe "#pick_winner" do
    let!(:entry) { create(:entry) }
    let(:entry_contest) { entry.contest }

    it "credit entry's owner by 'bounty' amount" do
      entry.user.should_receive(:credit).with(entry_contest.bounty)
      entry_contest.pick_winner(entry)
    end
  end
end
