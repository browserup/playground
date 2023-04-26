Rails.application.routes.draw do

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  post "/graphql", to: "graphql#execute"
  get "/healthcheck", to: "health_check#index"

  scope 'web' do
    resources :toys
    #   devise_for :users
    #root controller: :rooms, action: :index
    #resources :room_messages
    #resources :rooms
  end

  scope 'api' do
    resources :toys
    mount Rswag::Ui::Engine => '/api-docs'
    # mount Rswag::Api::Engine => '/api-docs'
    #    mount Rswag::Ui::Engine, at: 'toys-docs'
    mount Rswag::Api::Engine, at: 'toys-docs'
  end

  scope 'websocket' do
     devise_for :users, :skip => [:api, :toys, :graphql]
     root controller: :rooms, action: :index
    resources :room_messages
    resources :rooms
  end

end
