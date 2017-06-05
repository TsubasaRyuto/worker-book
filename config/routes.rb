Rails.application.routes.draw do
  get 'chats/show'

  # static_pages
  root to: 'static_pages#home'
  get '/sign_up', to: 'static_pages#signup'
  get '/worker/verify_email', to: 'static_pages#worker_verify_email'
  get '/client/verify_email', to: 'static_pages#client_verify_email'
  get '/privacy_policy', to: 'static_pages#privacy_policy'

  # sessions
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  # password_resets
  get '/forgot/password', to: 'password_resets#new', as: 'new_password_reset'
  get '/password/reset/:id/activate', to: 'password_resets#edit', as: 'edit_password_reset'
  post '/password_resets', to: 'password_resets#create', as: 'password_resets'
  patch '/password_reset/:id/', to: 'password_resets#update', as: 'password_reset_update'

  # skills
  get '/autocomplete_skill/:term', to: 'skills#autocomplete_skill', defaults: { format: 'json' }

  # chat
  get '/chat/messages/@:partner_username', to: 'chats#show'

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
      # worker受注内容確認
      get '/order_confirms/:client_clientname/:job_id/:token', to: 'order_confirms#show', as: 'order_confirms'

      # job_requestを受諾 or 不承諾
      post '/client/:client_clientname/:job_id/agreements', to: 'agreements#create', as: 'create_agreement'
      post '/client/:client_clientname/:job_id/request_refusal', to: 'agreements#refusal', as: 'request_refusal'
    end
  end

  # clients/
  scope '/client' do
    get '/sign_up', to: 'clients#new'
    get '/:clientname/settings/profile', to: 'clients#edit', as: 'client_settings_profile'
    resources :clients, except: %i(new edit), param: :clientname, path: '/' do

      get '/:token/activate', to: 'client_users#activate', as: 'activate_user'
      get '/:username/settings/account', to: 'client_users#edit', as: 'client_settings_account'
      resources :users, only: %i(update destroy), param: :username, path: '/', controller: :client_users do
        member { get '/retire', to: 'client_users#retire' }
      end

      get '/create_job', to: 'job_contents#new'
      # job_content選択
      get '/select/job_content/:worker_username', to: 'job_contents#select_job_content', as: 'select_job_content'
      # 発注内容確認
      get '/confirmation_order/:worker_username/job_content/:id', to: 'job_contents#show', as: 'confirmation_request_job'
      resources :jobs, only: %i(edit create update destroy), controller: :job_contents do
        # create job_request
        post '/request_job/:worker_username', to: 'job_requests#create', as: 'send_job_request'
      end
    end
  end

  # errors/
  get 'errors/error_404', to: 'errors#error_404'
  get 'errors/error_500', to: 'errors#error_500'

  mount ActionCable.server => '/cable'
end
