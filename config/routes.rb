# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts
  resources :todos
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'todos#index'

  resources :todos do
    member do
      patch 'edit', to: 'todos#update'
    end
  end
end
