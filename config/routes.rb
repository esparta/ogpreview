# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'preview#show'
  post '/', to: 'preview#create'
end
