Rails.application.routes.draw do
  
  mount Blacklight::Engine => '/'
  
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

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
  resources :data_paper_api, module: 'hyrax', path: 'data_paper_api', :defaults => { :format => :json }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :admin do
    get 'sign_in', to: 'sign_in#show'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
