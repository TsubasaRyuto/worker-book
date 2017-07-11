def signed_in?
  !session[:user_id].nil?
end

def user_type(user)
  if user.class == Worker
    'worker'
  elsif user.class == ClientUser
    'client'
  else
    false
  end
end

def signed_on?(user)
  if user_type(user) == 'worker'
    urls = ["/#{user_type(user)}/#{user.username}/create_profile", "/#{user_type(user)}/#{user.username}"]
    page.has_link? user.username.to_s if urls.include?(current_path)
  elsif user_type(user) == 'client'
    urls = ["/#{user_type(user)}/#{user.client.clientname}"]
    page.has_link? user.client.name.to_s if urls.include?(current_path)
  end
  page.has_link? 'Sign out'
end

def sign_in_as(user)
  session[:user_id] = user.username
end

def sign_on_as(user, option = {})
  remember_me = option[:remember_me] || '1'
  visit '/sign_in'
  fill_in placeholder: 'メールアドレス', with: user.email
  fill_in placeholder: 'パスワード', with: user.password
  check 'サインイン状態を維持する' if remember_me == '1'
  click_button 'サインイン'
end
