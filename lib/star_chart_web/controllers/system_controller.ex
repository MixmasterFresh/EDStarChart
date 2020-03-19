defmodule StarChartWeb.SystemController do
  use StarChartWeb, :controller

  alias StarChart.Data
  alias StarChart.Data.System

  action_fallback StarChartWeb.FallbackController

  def index(conn, _params) do
    systems = Data.list_systems()
    render(conn, "index.json", systems: systems)
  end

  def create(conn, %{"system" => system_params}) do
    with {:ok, %System{} = system} <- Data.create_system(system_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.system_path(conn, :show, system))
      |> render("show.json", system: system)
    end
  end

  def show(conn, %{"id" => id}) do
    system = Data.get_system!(id)
    render(conn, "show.json", system: system)
  end
end
