Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/sign_up', to: 'static_pages#signup'
  get '/worker/verify_email', to: 'static_pages#worker_verify_email'
  get '/client/verify_email', to: 'static_pages#client_verify_email'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/forgot/password', to: 'password_resets#new', as: 'new_password_reset'
  get '/password/reset/:id/activate', to: 'password_resets#edit', as: 'edit_password_reset'
  post '/password_resets', to: 'password_resets#create', as: 'password_resets'
  patch '/password_reset/:id/', to: 'password_resets#update', as: 'password_reset_update'
  get '/autocomplete_skill/:term', to: 'skills#autocomplete_skill', defaults: { format: 'json' }

  # workers/
  scope '/worker' do
    get '/:token/activate', to: 'workers#activate', as: 'activate_worker'
    get '/:username/settings/account', to: 'workers#edit', as: 'worker_settings_account'
    get '/sign_up', to: 'workers#new'
    resources :workers, except: %i(new edit), param: :username, path: '/' do
      member { get '/retire', to: 'workers#retire' }

      get '/create_profile', to: 'worker_profiles#new'
      get '/settings/profile', to: 'worker_profiles#edit'
      resource :profiles, only: %i(create update), controller: :worker_profiles
    end
  end

  # clients/
  scope '/client' do
    get '/sign_up', to: 'clients#new'
    get '/:clientname/settings/profile', to: 'clients#edit', as: 'client_settings_profile'
    resources :clients, except: %i(new edit), param: :clientname, path: '/' do

      get '/:token/activate', to: 'client_users#activate', as: 'activate_user'
      get '/:username/settings/account', to: 'client_users#edit', as: 'client_settings_account'
      resources :users, except: %i(new edit create index), param: :username, path: '/', controller: :client_users do
        member { get '/retire', to: 'client_users#retire' }

        get '/create_job', to: 'jobs#new'
        resources :jobs, only: %i(show edit create update destroy), controller: :client_jobs
      end
    end
  end

  # errors/
  get 'errors/error_404', to: 'errors#error_404'
  get 'errors/error_500', to: 'errors#error_500'
end
