def signed_in?
  !session[:worker_id].nil?
end

def signed_on?(worker)
  if current_path == worker_path(username: worker.username) || current_path == worker_create_profile_path(worker_username: worker.username)
    click_link "#{worker.username}"
    page.has_link? 'Sign out'
  end
end

def sign_in_as(worker)
  session[:worker_id] = worker.id
end

def sign_on_as(worker, option = {})
  remember_me = option[:remember_me] || '1'
  visit '/sign_in'
  fill_in placeholder: 'Email', with: worker.email
  fill_in placeholder: 'Password', with: worker.password
  check 'Remember me' if remember_me == '1'
  click_button 'Sign In'
end
