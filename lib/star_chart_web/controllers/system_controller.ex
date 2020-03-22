defmodule StarChartWeb.SystemController do
  use StarChartWeb, :controller
  use Params

  alias StarChart.Data
  alias StarChart.Data.System

  action_fallback StarChartWeb.FallbackController

  def index(conn, _params) do
    systems = Data.list_systems()
    render(conn, "many.json", systems: systems)
  end

  def create(conn, %{"system" => system_params}) do
    with {:ok, %System{} = system} <- Data.create_system(system_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.system_path(conn, :show, system))
      |> render("show.json", system: system)
    end
  end

  def show(conn, %{"system_address" => system_address}) do
    system = Data.get_system!(system_address)
    render(conn, "show.json", system: system)
  end

  defparams grid_params %{
    x: :integer,
    y: :integer,
    z: :integer
  }

  def grid_query(conn, params) do
    changeset = grid_params(params)
    if changeset.valid? do
      systems = changeset
      |> Params.data
      |> Data.get_systems_in_block
      render(conn, "many.json", systems: systems)
    else
      conn
      |> put_status(:bad_request)
      |> text("Bad Request Parameters")
    end
  end
end
