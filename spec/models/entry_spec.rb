require 'spec_helper'

describe Entry do
  subject { create(:entry) }

  it {should belong_to(:user)}
  it {should belong_to(:contest)}

  it {should validate_presence_of(:contest)}
  it {should validate_presence_of(:user)}
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:data_set_url)}
  it {should ensure_inclusion_of(:rating).in_array(1..5) }
  it {should validate_uniqueness_of(:user_id).with_message("cannot enter contest twice").scoped_to(:contest_id)}

  describe '.update_rating' do
    let(:entry) { create(:entry) }
    let(:new_rating) { 5 }
    let(:invalid_rating) { 7 }
    it "should set valid rating of entry" do
      expect(entry.update_rating(new_rating)).to be_true
      expect(entry.rating).to eq(new_rating)
    end

    it "should not set valid rating of entry" do
      expect(entry.update_rating(invalid_rating)).to be_false
      expect(entry.reload.rating).not_to eq(invalid_rating)
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
