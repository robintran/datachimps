def login(user)
  visit new_user_session_path
  within "#new_user" do
    fill_in "user[email]", :with => user.email
    fill_in "user[password]", :with => "12345678"
    click_on "Sign in"
  end
end

def wait_until timeout=5
  Timeout::timeout(timeout) do
    sleep(1) until yield
  end
end

def wait_for_jquery
  wait_until do
    page.evaluate_script('window.jQuery')
  end
end
