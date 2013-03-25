require 'spec_helper'

describe 'Contest following' do
  include_context 'capybara-login'
  let!(:contest) { create :contest, user: user }
  let!(:another_contest) { create :contest }

  describe 'List all following contests' do
    before do
        user.follow(another_contest)
        visit contest_followings_path
      end

      it 'should auto-following your own contest' do
        page.should have_link contest.name, href: contest_path(contest)
        page.should have_link 'Unfollow', href: contest_following_path(user.contest_following_for(contest))
      end

      it 'should show other contests that you follow' do
        page.should have_link another_contest.name, href: contest_path(another_contest)
        page.should have_link 'Unfollow', href: contest_following_path(user.contest_following_for(another_contest))
      end
  end

  describe 'Following a contest' do
    context 'following a new contest' do
      before do
        visit contests_path
        find(:xpath, "//a[@href='#{contest_followings_path(contest_following: { contest_id: another_contest.id })}']", text: 'Follow').click
      end

      it 'should be able to follow a contest' do
        wait_until do
          current_path == contest_followings_path
        end
        page.should have_link another_contest.name
      end
    end
  end

  describe 'Unfollowing a contest', js: true do
    before do
      user.follow(another_contest)
      visit contests_path
      find(:xpath, "//a[@href='#{contest_following_path(user.contest_following_for(another_contest))}']", text: 'Unfollow').click
      page.driver.browser.switch_to.alert.accept
    end

    it 'should remove the contest from the following list' do
      page.should have_link 'Follow', contest_followings_path(contest_following: { contest_id: another_contest.id })
    end
  end
end
