defmodule CanvasServerWeb.Router do
  use CanvasServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CanvasServerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CanvasServerWeb do
    pipe_through :browser

    live "/", DrawingLive.Index, :index

    live "/drawings", DrawingLive.Index, :index
    live "/drawings/new", DrawingLive.Index, :new
    live "/drawings/:id/edit", DrawingLive.Index, :edit

    live "/drawings/:id", DrawingLive.Show, :show
    live "/drawings/:id/show/edit", DrawingLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", CanvasServerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: CanvasServerWeb.Telemetry
    end
  end
end
