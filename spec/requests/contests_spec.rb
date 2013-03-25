require 'spec_helper'

describe 'Contest pages' do
  let(:user) { create(:user) }
  let(:contest) { create(:contest, :name => 'Datachimps contest', :user => user) }
  let(:contest_attributes) do
    {
      name: 'contest_name',
      description: 'contest_description',
      bounty: 100
    }
  end

  before do
    login_as(user, :scope => :user)
  end

  describe 'List contests' do
    let!(:contests) { create_list :contest, 1, user: user }

    before do
      visit contests_path
    end

    it 'shows correct contests content' do
      contests.each do |contest|
        contest_attributes.each do |k, _|
          page.should have_content(contest.send(k))
        end
        page.should have_link('Edit', href: edit_contest_path(contest))
        page.should have_link('Destroy', href: contest_path(contest))
        page.should have_link(contest.name, href: contest_path(contest))
      end
    end
  end

  describe "Create a contest" do
    before do
      visit root_path
      click_on 'New Contest'
    end

    it 'allows owner to set bounty value for new contest' do
      page.should_not have_css("#contest_bounty[disabled]")
    end

    context 'create' do
      before do
        within "#new_contest" do
          contest_attributes.each do |k, v|
            fill_in "contest[#{k}]", with: v
          end
          click_on "Save"
        end
      end

      it "creates contest with correct value" do
        page.should have_content 'Contest was successfully created.'
        contest_attributes.each do |k, v|
          page.should have_content "#{k.to_s.camelize}: #{v}"
        end
      end
    end
  end

  describe "Edit a contest" do
    before do
      visit edit_contest_path(contest)
    end

    it "disables bounty input for created contests" do
      within "#edit_contest_#{contest.id}" do
        page.should have_css("#contest_bounty[disabled]")
      end
    end

    context 'edit with invalid value' do
      before do
        contest_attributes.except!(:bounty).each do |k, v|
          fill_in "contest[#{k}]", with: ''
        end
        click_on "Save"
      end

      it 'should show error messages' do
        contest_attributes.each do |k, v|
          page.should have_content "#{k.to_s.camelize} can't be blank"
        end
      end
    end

    context 'edit successfully' do
      before do
        contest_attributes.except!(:bounty).each do |k, v|
          fill_in "contest[#{k}]", with: v
        end
        click_on "Save"
      end

      it 'updates contest with correct values' do
        page.should have_content 'Contest was successfully updated.'
        contest_attributes.each do |k, v|
          page.should have_content "#{k.to_s.camelize}: #{v}"
        end
      end
    end
  end

  describe 'Destroy a contest', js: true do
    before do
      contest
      visit contests_path
      find_link('Destroy').click
      page.driver.browser.switch_to.alert.accept
    end

    it 'should destroy the contest' do
      wait_until do
        !Contest.exists?(id: contest.id)
      end
    end
  end

  describe 'Expired contest' do
    let(:expired_contest) { create :contest, user: user, deadline: 1.day.ago }

    before do
      visit contest_path(expired_contest)
    end

    it 'shows a message forcing the contest owner to pick an winner' do
      page.should have_content 'Contest has passed deadline, please choose a winner'
    end
  end
end
