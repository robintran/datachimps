require 'spec_helper'

describe 'Pending contests' do
  include_context 'capybara-login'

  let!(:contests) { create_list :contest, 1, entries: create_list(:entry, 1, user: user) }

  describe 'List pending contests' do
    before do
      visit pending_contests_path
    end

    it 'should show pending contests' do
      contests.each do |contest|
        [:name, :description, :bounty].each do |attr|
          page.should have_content contest.send(attr)
        end
      end
    end
  end
end
