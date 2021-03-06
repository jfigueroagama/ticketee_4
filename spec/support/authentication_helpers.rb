module AuthenticationHelpers
  
  def sign_in_as!(user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    
    expect(page).to have_content("Signed in successfully.")  
  end
end

# This includes the AuthenticationHelpers in all the specs in spec/features directory
RSpec.configure do |c|
  c.include AuthenticationHelpers, type: :feature
end

module AuthHelpers
  def sign_in(user)
    session[:user_id] = user.id
  end
end

# This includes the AuthHelpers in all the specs for controllers
RSpec.configure do |c|
  c.include AuthHelpers, type: :controller
end
