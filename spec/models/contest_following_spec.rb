require 'spec_helper'

describe ContestFollowing do
  [:user, :contest].each do |association|
    it { should belong_to association }
  end

  [:contest, :contest_id].each do |attr|
    it { should allow_mass_assignment_of attr }
  end

  [:user_id, :contest_id].each do |attr|
    it { should validate_presence_of attr }
  end

  it { should validate_uniqueness_of(:user_id).scoped_to(:contest_id) }
end
