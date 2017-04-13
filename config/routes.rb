Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/sign_up', to: 'static_pages#signup'
  get '/verify_email', to: 'static_pages#verify_email'
  get 'workers/:token/activate', to: 'workers#activate', as: 'activate_worker'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :workers, except: %i(new), param: :username, path: '/' do
    collection do
      get '/autocomplete_skill/:term', to: 'workers#autocomplete_skill', defaults: { format: 'json' }
    end

    get '/create_profile', to: 'worker_profiles#new'
    get '/settings/profile', to: 'worker_profiles#edit'
    resource :profiles, only: %i(create update), path: '/', controller: :worker_profiles
  end

  resources :clients, except: %i(new), param: :username, path: '/' do
    get '/create_profile', to: 'profiles#new'
    get '/create_job', to: 'jobs#new'
    resource :profiles, only: %i(create), controller: :client_profiles
    resources :jobs, only: %i(show create update destroy), controller: :client_jobs
  end

  scope '/worker' do
    get '/sign_up', to: 'workers#new'
  end

  scope '/client' do
    get '/sign_up', to: 'clients#new'
  end
end
