def signed_in?
  !session[:user_id].nil?
end

def user_type(user)
  if user.class == Worker
    'worker'
  elsif user.class == Client
    'client'
  else
    false
  end
end

def signed_on?(user)
  urls = ["/#{user_type(user)}/#{user.username}/create_profile", "/#{user_type(user)}/#{user.username}"]
  if urls.include?(current_path)
    click_link user.username.to_s
    page.has_link? 'Sign out'
  end
end

def sign_in_as(user)
  session[:user_id] = user.id
end

def sign_on_as(user, option = {})
  remember_me = option[:remember_me] || '1'
  visit '/sign_in'
  fill_in placeholder: 'Email', with: user.email
  fill_in placeholder: 'Password', with: user.password
  check 'Remember me' if remember_me == '1'
  click_button 'Sign In'
end
