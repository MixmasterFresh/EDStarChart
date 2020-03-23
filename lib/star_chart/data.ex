defmodule StarChart.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias StarChart.Repo

  alias StarChart.Data.System

  @doc """
  Returns the list of systems.

  ## Examples

      iex> list_systems()
      [%System{}, ...]

  """
  def list_systems do
    Repo.all(from System, limit: 1000)
  end

  @doc """
  Gets a single system.

  Raises `Ecto.NoResultsError` if the System does not exist.

  ## Examples

      iex> get_system!(123)
      %System{}

      iex> get_system!(456)
      ** (Ecto.NoResultsError)

  """
  def get_system!(system_address), do: Repo.get!(System, system_address)

  @doc """
  Creates a system.

  ## Examples

      iex> create_system(%{field: value})
      {:ok, %System{}}

      iex> create_system(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_system(attrs \\ %{}) do
    %System{}
    |> System.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a system.

  ## Examples

      iex> update_system(system, %{field: new_value})
      {:ok, %System{}}

      iex> update_system(system, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_system(%System{} = system, attrs) do
    system
    |> System.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a system.

  ## Examples

      iex> delete_system(system)
      {:ok, %System{}}

      iex> delete_system(system)
      {:error, %Ecto.Changeset{}}

  """
  def delete_system(%System{} = system) do
    Repo.delete(system)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking system changes.

  ## Examples

      iex> change_system(system)
      %Ecto.Changeset{source: %System{}}

  """
  def change_system(%System{} = system) do
    System.changeset(system, %{})
  end

  def get_systems_in_block(data) do
    block = get_block(data.x, data.y, data.z)
    Repo.all(from system in System,
      where: system.x >= ^block.x_min and system.x < ^block.x_max,
      where: system.y >= ^block.y_min and system.y < ^block.y_max,
      where: system.z >= ^block.z_min and system.z < ^block.z_max
    )
  end

  defp get_block(x, y, z) do
    block_size = 50
    x_factor = trunc(x / block_size) * block_size
    y_factor = trunc(y / block_size) * block_size
    z_factor = trunc(z / block_size) * block_size
    %{
      x_min: x_factor,
      y_min: y_factor,
      z_min: z_factor,
      x_max: x_factor + block_size,
      y_max: y_factor + block_size,
      z_max: z_factor + block_size
    }
  end
end
