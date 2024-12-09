defmodule RealDealApiWeb.Router do
  use RealDealApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RealDealApiWeb do
    pipe_through :api

    get "/", DefaultController, :index
    resources "/accounts", AccountController#, only: [:index, :create]
    resources "/users", UserController, only: [:show, :update]
  end
end
