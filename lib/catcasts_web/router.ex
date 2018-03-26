defmodule CatcastsWeb.Router do
  use CatcastsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Catcasts.Plugs.SetUser
  end

  pipeline :auth do
    plug CatcastsWeb.Plugs.RequireAuth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CatcastsWeb do
    pipe_through [:browser, :auth]

    resources "/videos", VideoController, only: [:new, :create, :delete]
  end

  scope "/", CatcastsWeb do
    pipe_through :browser # Use the default browser stack

    resources "/videos", VideoController, only: [:index, :show]
    get "/", PageController, :index
  end

  scope "/auth", CatcastsWeb do
    pipe_through :browser

    get "/signout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", CatcastsWeb do
  #   pipe_through :api
  # end
end
