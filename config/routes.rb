Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/sign_up', to: 'static_pages#signup'
  get '/verify_email', to: 'static_pages#verify_email'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/forgot/password', to: 'password_resets#new', as: 'new_password_reset'
  get '/password/reset/:id/activate', to: 'password_resets#edit', as: 'edit_password_reset'
  post '/password_resets', to: 'password_resets#create', as: 'password_resets'
  patch '/password_reset/:id/', to: 'password_resets#update', as: 'password_reset_update'

  # workers/
  get 'workers/:token/activate', to: 'workers#activate', as: 'activate_worker'
  get '/:username/settings/account', to: 'workers#edit', as: 'worker_settings_account'
  scope '/worker' do
    get '/sign_up', to: 'workers#new'
  end
  resources :workers, except: %i(new edit), param: :username, path: '/' do
    collection { get '/autocomplete_skill/:term', to: 'workers#autocomplete_skill', defaults: { format: 'json' } }
    member { get '/retire', to: 'workers#retire' }

    get '/create_profile', to: 'worker_profiles#new'
    get '/settings/profile', to: 'worker_profiles#edit'

    resource :profiles, only: %i(create update), controller: :worker_profiles
  end

  # clients/
  scope '/client' do
    get '/sign_up', to: 'clients#new'
  end
  resources :clients, except: %i(new), param: :username, path: '/' do
    resource :profiles, only: %i(create update), controller: :client_profiles
    resources :jobs, only: %i(show edit create update destroy), controller: :client_jobs
    get '/create_profile', to: 'profiles#new'
    get '/create_job', to: 'jobs#new'
  end

  # errors/
  get 'errors/error_404', to: 'errors#error_404'
  get 'errors/error_500', to: 'errors#error_500'
end
