shared_context 'capybara-login', login: true do
  let(:user) { create :user }

  before do
    login_as(user, :scope => :user)
  end
end
