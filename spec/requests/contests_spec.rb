require 'spec_helper'

describe 'Contest pages', :js => true do
  let(:user) { create(:user) }
  let!(:contest) { create(:contest, :name => 'Datachimps contest', :user => user) }
  before { login(user) }

  describe "Create a contest" do
    it "allow owner to set bounty value" do
      click_on "New Contest"
      within "#new_contest" do
        page.should_not have_css("#contest_bounty[disabled]")
        fill_in "contest[name]", :with => 'Contest 1'
        fill_in "contest[description]", :with => "Desc"
        fill_in "contest[bounty]", :with => "4"
        click_on "Save"
      end
      page.driver.browser.switch_to.alert.accept
      page.should have_content "Name: Contest 1"
      page.should have_content "Bounty: 4"
    end
  end

  describe "Edit a contest" do
    it "disable bounty input" do
      click_on "Edit"
      within "#edit_contest_#{contest.id}" do
        page.should have_css("#contest_bounty[disabled]")
      end
    end
  end
end
