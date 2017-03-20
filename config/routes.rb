Rails.application.routes.draw do
  root to: 'static_pages#home'
  get '/signup', to: 'static_pages#signup'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy'

  resources :workers, except: %i(new), param: :workername, path: '/' do
    get '/create_profile', to: 'profiles#new'
    resource :profiles, only: %i(create), path: '/' do
      scope '/profile' do
        member do
          get :confirm
        end
      end
    end
  end


  resources :clients, except: %i(new), param: :clientname, path: '/' do
    get '/create_profile', to: 'profiles#new'
    get '/create_job', to: 'jobs#new'
    resource :profiles, only: %i(create)
    resources :jobs, only: %i(show create update destroy)
  end


  scope '/worker' do
    get '/sign_up', to: 'workers#new'
  end

  scope '/client' do
    get '/sign_up', to: 'clients#new'
  end
end
