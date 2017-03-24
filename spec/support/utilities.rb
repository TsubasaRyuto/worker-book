def signed_in?
  !session[:worker_id].nil?
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
  click_button 'サインイン'
end
