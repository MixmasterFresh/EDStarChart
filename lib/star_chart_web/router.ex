defmodule StarChartWeb.Router do
  use StarChartWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StarChartWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", StarChartWeb do
    pipe_through :api

    resources "/system", SystemController, except: [:create, :delete]
  end
end
