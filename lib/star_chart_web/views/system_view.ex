defmodule StarChartWeb.SystemView do
  use StarChartWeb, :view
  alias StarChartWeb.SystemView

  def render("index.json", %{systems: systems}) do
    %{data: render_many(systems, SystemView, "system.json")}
  end

  def render("show.json", %{system: system}) do
    %{data: render_one(system, SystemView, "system.json")}
  end

  def render("system.json", %{system: system}) do
    %{id: system.id,
      name: system.name,
      system_address: system.system_address,
      x: system.x,
      y: system.y,
      z: system.z}
  end
end
