Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "page_layout#home"

    get "page_layout/home"
    get "page_layout/about"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users
    resources :budgets, only: %i(new create) do
      collection do
        get "/:parent_id/new", to: "budgets#new"
        post "/:parent_id", to: "budgets#create", as: "with_parent"
      end
    end
    resources :spending_plans
  end
end
