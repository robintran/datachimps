require 'spec_helper'

describe Entry do
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
end
