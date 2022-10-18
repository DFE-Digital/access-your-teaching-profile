require "sidekiq/web"

Rails.application.routes.draw do
  root to: "pages#home"
  get "_sha", to: ->(_) { [200, {}, [ENV.fetch("GIT_SHA", "")]] }

  get "/accessibility", to: "static#accessibility"
  get "/cookies", to: "static#cookies"
  get "/privacy", to: "static#privacy"

  namespace :support_interface, path: "/support" do
    get "/", to: redirect("/support/features")

    get "/features", to: "feature_flags#index"
    post "/features/:feature_name/activate",
         to: "feature_flags#activate",
         as: :activate_feature
    post "/features/:feature_name/deactivate",
         to: "feature_flags#deactivate",
         as: :deactivate_feature

    mount Sidekiq::Web, at: "sidekiq"
  end

  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end
end
