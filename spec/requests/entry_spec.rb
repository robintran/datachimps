require 'spec_helper'

describe 'Entry' do
  include_context 'capybara-login'
  let(:contest) { create :contest, user: user }
  let(:another_contest) { create :contest }


  shared_examples_for 'could not add more entries' do
    it 'could not add more entry to the contest' do
      page.should_not have_link('Add entry', href: new_contest_entry_path(contest))
    end
  end

  describe 'Add entry' do
    context 'the contest has a winner' do
      before do
        User.any_instance.stub(:credit)
        contest.update_attributes(winner: create(:entry))
        visit contest_path(contest)
      end

      it_should_behave_like 'could not add more entries'
    end

    context 'the contest has expired' do
      before do
        contest.update_attributes(deadline: 1.day.ago)
        visit contest_path(contest)
      end

      it_should_behave_like 'could not add more entries'
    end

    context 'cannot submit more than one entry for 1 contest' do

      before do
        create(:entry, contest: another_contest, user: user)
        visit new_contest_entry_path(another_contest)
      end

      it 'should show error message' do
        wait_until do
          current_path == contest_path(another_contest)
        end
        page.should have_content 'You cannot enter contest twice'
      end
    end

    context 'cannot submit entry on your own contest' do
      before do
        visit new_contest_entry_path(contest)
      end

      it 'should redirect to contest_path and show error message' do
        current_path.should == contest_path(contest)
        page.should have_content 'Cannot enter your own contest.'
      end
    end

    context 'submit new entry' do

      context 'invalid entry' do
        before do
          visit new_contest_entry_path(another_contest)
          click_button 'Save'
        end

        it 'should show error messages' do
          page.should have_content "Description can't be blank"
          page.should have_content "Data set url can't be blank"
        end
      end

      context 'valid entry', js: true do
        let(:entry_description) { 'entry_description' }
        let(:entry_dataset_url) { 'entry_dataset_url' }

        before do
          visit new_contest_entry_path(another_contest)
          fill_in 'entry_description', with: entry_description
          page.execute_script("$('#entry_data_set_url').val('#{entry_dataset_url}')")
          click_button 'Save'
        end

        it 'should save the entry' do
          page.should have_content 'Entry was successfully created.'
          page.should have_content entry_description
          page.should have_content entry_dataset_url
        end
      end
    end
  end

  describe 'Remove an entry' do
    context 'Remove contestant from contest' do
      let!(:entry) { create :entry, contest: contest }

      before do
        visit contest_path(contest)
      end

      it 'should be able for the owner to remove the contestant from contest' do
        page.should have_link 'Remove this entry', href: remove_contest_entry_path(contest, entry)
      end

      context 'remove an entry', js: true do
        before do
          click_link 'Remove this entry'
          page.driver.browser.switch_to.alert.accept
        end

        it 'should not be visible to the contest owner' do
          page.should_not have_content entry.description
        end
      end
    end

    context 'your entry has been removed' do
      let(:your_entry) { create :entry, user: user, contest: another_contest }

      before do
        your_entry.remove
        visit contest_path(another_contest)
        click_link 'Add entry'
      end

      it 'should not allow you to submit any new entry' do
        page.should have_content 'You cannot enter contest twice.'
      end
    end
  end

  describe 'Rate an entry' do
    context 'entries of other contest' do
      let!(:entry) { create :entry, contest: another_contest }

      before do
        visit contest_path(another_contest)
      end

      it 'should not show rating span' do
        page.should_not have_selector "div.rating#entry-rating-#{entry.id}"
      end
    end

    context 'entries of my own contest', js: true do
      let!(:entry) { create :entry, contest: contest }

      before do
        visit contest_path(contest)
      end

      ['quality', 'amount', 'speed'].each do |dimension|
        context "#{dimension}" do
          before do
            wait_for_jquery
            page.execute_script("$('#entry-rating-#{entry.id} .ajaxful-rating a[href*=#{dimension}].stars-1').click()")
          end

          it "should allow rating #{dimension} of the entry" do
            wait_until do
              entry.send("#{dimension}_rates").try(:first).try(:stars) == 1
            end
          end
        end
      end
    end
  end

  describe 'List entries' do
    context 'entries of another contest' do
      let!(:entries) { create_list :entry, 1, contest: another_contest, feedbacks: create_list(:feedback, 2, user: another_contest.user)  }

      before do
        visit contest_path(another_contest)
      end

      it 'should show the name of the contestant' do
        entries.each do |entry|
          page.should_not have_link entry.user.name, href: contest_entry_path(contest, entry)
          page.should have_content entry.user.name
        end
      end

      it 'should not show entries feedbacks count' do
        entries.each do |entry|
          page.should_not have_content "#{entry.feedbacks.count} feedbacks"
        end
      end

      it 'should not show entries dataset'do
        entries.each do |entry|
          page.should_not have_content entry.data_set_url
        end
      end
    end

    context 'entries of my own contest' do
      let!(:entries) { create_list :entry, 1, contest: contest }

      before do
        visit contest_path(contest)
      end

      it 'should show link to the entry detail' do
        entries.each do |entry|
          page.should have_link entry.user.name, href: contest_entry_path(contest, entry)
        end
      end

      it 'should show entries dataset'do
        entries.each do |entry|
          page.should have_content entry.data_set_url
        end
      end

      it 'should show entries feedbacks count' do
        entries.each do |entry|
          page.should have_content "#{entry.feedbacks.count} feedbacks"
        end
      end
    end
  end

  describe 'Show entries' do
    context 'entries of my own contest' do
      let(:entry) { create :entry, contest: contest }

      before do
        visit contest_entry_path(contest, entry)
      end

      it 'should show correct content' do
        [:description, :data_set_url].each do |attr|
          page.should have_content(entry.send(attr))
        end
        page.should have_link 'Add feedback', new_contest_entry_feedback_path(contest, entry)
      end
    end

    context 'entries of other contest' do
      let(:entry) { create :entry, contest: another_contest }

      before do
        visit contest_entry_path(another_contest, entry)
      end

      it 'should show error message' do
        wait_until do
          current_path == contest_path(another_contest)
        end
        page.should have_content 'You cannot view other submitted entries'
      end
    end
  end
end
