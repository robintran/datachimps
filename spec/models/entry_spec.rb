require 'spec_helper'

describe Entry do
  it {should belong_to(:user)}
  it {should belong_to(:contest)}

  describe 'validations' do
    subject { create(:entry) }
    it {should validate_presence_of(:contest)}
    it {should validate_presence_of(:user)}
    it {should validate_presence_of(:description)}
    it {should validate_presence_of(:data_set_url)}
    it {should validate_uniqueness_of(:user_id).with_message(/cannot enter contest twice/).scoped_to(:contest_id)}
  end

  describe '.remove' do
    let(:entry) { create(:entry) }

    it "set removed to true" do
      expect(entry.remove).to be_true
      expect(entry.removed).to be_true
    end
  end

  describe "#follow_contest after create" do
    let(:entry) { build(:entry) }

    it "call #follow_contest" do
      entry.should_receive(:follow_contest)
      entry.save
    end

    it "let user follow the entry's contest" do
      entry.user.should_receive(:follow).with(entry.contest)
      entry.save
    end
  end

  describe "on_create" do
    describe "#owner_has_account" do
      let(:entry) { build(:entry) }

      context "create" do
        it "should be called" do
          entry.should_receive(:owner_has_account).and_return true
          entry.save
        end

        it "add error message when 'balanced_account_uri' is blank" do
          entry.user.stub(:balanced_account_uri).and_return nil
          entry.save
          entry.should_not be_valid
          entry.errors.messages[:base].should == ["Owner must have an account to create a new entry."]
        end
      end

      context "update" do
        it "should not be called" do
          entry.save
          entry.should_not_receive(:owner_has_account)
          entry.update_attributes(:description => 'New desc')
        end
      end
    end
  end
end
