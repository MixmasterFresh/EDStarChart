defmodule StarChart.DataTest do
  use StarChart.DataCase

  alias StarChart.Data

  describe "systems" do
    alias StarChart.Data.System

    @valid_attrs %{name: "some name", system_address: 42, type: "some type", x: 120.5, y: 120.5, z: 120.5}
    @update_attrs %{name: "some updated name", system_address: 43, type: "some updated type", x: 456.7, y: 456.7, z: 456.7}
    @invalid_attrs %{name: nil, system_address: nil, type: nil, x: nil, y: nil, z: nil}

    def system_fixture(attrs \\ %{}) do
      {:ok, system} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_system()

      system
    end

    test "list_systems/0 returns all systems" do
      system = system_fixture()
      assert Data.list_systems() == [system]
    end

    test "get_system!/1 returns the system with given id" do
      system = system_fixture()
      assert Data.get_system!(system.id) == system
    end

    test "create_system/1 with valid data creates a system" do
      assert {:ok, %System{} = system} = Data.create_system(@valid_attrs)
      assert system.name == "some name"
      assert system.system_address == 42
      assert system.type == "some type"
      assert system.x == 120.5
      assert system.y == 120.5
      assert system.z == 120.5
    end

    test "create_system/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_system(@invalid_attrs)
    end

    test "update_system/2 with valid data updates the system" do
      system = system_fixture()
      assert {:ok, %System{} = system} = Data.update_system(system, @update_attrs)
      assert system.name == "some updated name"
      assert system.system_address == 43
      assert system.type == "some updated type"
      assert system.x == 456.7
      assert system.y == 456.7
      assert system.z == 456.7
    end

    test "update_system/2 with invalid data returns error changeset" do
      system = system_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_system(system, @invalid_attrs)
      assert system == Data.get_system!(system.id)
    end

    test "delete_system/1 deletes the system" do
      system = system_fixture()
      assert {:ok, %System{}} = Data.delete_system(system)
      assert_raise Ecto.NoResultsError, fn -> Data.get_system!(system.id) end
    end

    test "change_system/1 returns a system changeset" do
      system = system_fixture()
      assert %Ecto.Changeset{} = Data.change_system(system)
    end
  end
end
