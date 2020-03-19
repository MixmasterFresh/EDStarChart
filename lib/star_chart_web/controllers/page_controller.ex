defmodule StarChartWeb.PageController do
  use StarChartWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
