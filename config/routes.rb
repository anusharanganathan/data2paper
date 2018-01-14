Rails.application.routes.draw do
  
  mount Blacklight::Engine => '/'
  
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks"}
  # devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", sessions: 'sessions', registrations: 'registrations' }

  mount Hydra::RoleManagement::Engine => '/'

  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  resources :list_journals, only: :index, module: 'hyrax', path: '/journals'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :admin do
    get 'sign_in', to: 'sign_in#show'
  end


  namespace :api do
    resources :data_paper, :defaults => { :format => :json }
    post 'authenticate', to: 'authentication#authenticate', :defaults => { :format => :json }
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
