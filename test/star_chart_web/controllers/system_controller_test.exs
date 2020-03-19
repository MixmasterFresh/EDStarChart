defmodule StarChartWeb.SystemControllerTest do
  use StarChartWeb.ConnCase

  alias StarChart.Data
  alias StarChart.Data.System

  @create_attrs %{
    name: "some name",
    system_address: 42,
    type: "some type",
    x: 120.5,
    y: 120.5,
    z: 120.5
  }
  @update_attrs %{
    name: "some updated name",
    system_address: 43,
    type: "some updated type",
    x: 456.7,
    y: 456.7,
    z: 456.7
  }
  @invalid_attrs %{name: nil, system_address: nil, type: nil, x: nil, y: nil, z: nil}

  def fixture(:system) do
    {:ok, system} = Data.create_system(@create_attrs)
    system
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all systems", %{conn: conn} do
      conn = get(conn, Routes.system_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create system" do
    test "renders system when data is valid", %{conn: conn} do
      conn = post(conn, Routes.system_path(conn, :create), system: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.system_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "system_address" => 42,
               "type" => "some type",
               "x" => 120.5,
               "y" => 120.5,
               "z" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.system_path(conn, :create), system: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update system" do
    setup [:create_system]

    test "renders system when data is valid", %{conn: conn, system: %System{id: id} = system} do
      conn = put(conn, Routes.system_path(conn, :update, system), system: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.system_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "system_address" => 43,
               "type" => "some updated type",
               "x" => 456.7,
               "y" => 456.7,
               "z" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, system: system} do
      conn = put(conn, Routes.system_path(conn, :update, system), system: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete system" do
    setup [:create_system]

    test "deletes chosen system", %{conn: conn, system: system} do
      conn = delete(conn, Routes.system_path(conn, :delete, system))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.system_path(conn, :show, system))
      end
    end
  end

  defp create_system(_) do
    system = fixture(:system)
    {:ok, system: system}
  end
end
