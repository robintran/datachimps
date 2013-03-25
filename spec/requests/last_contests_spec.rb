require 'spec_helper'

describe 'Last contests' do
  include_context 'capybara-login'

  let(:contests) { create_list :contest, 1, winner: create(:entry), entries: create_list(:entry, 1, user: user) }

  describe 'List pending contests' do
    before do
      User.any_instance.stub(:credit)
      contests
      visit past_contests_path
    end

    it 'should show last contests' do
      contests.each do |contest|
        [:name, :description, :bounty].each do |attr|
          page.should have_content contest.send(attr)
        end
        page.should have_content contest.winner.user.name
      end
    end
  end
end

