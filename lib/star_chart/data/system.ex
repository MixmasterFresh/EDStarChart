defmodule StarChart.Data.System do
  use Ecto.Schema
  import Ecto.Changeset

  schema "systems" do
    field :name, :string
    field :system_address, :integer
    field :x, :float
    field :y, :float
    field :z, :float

    timestamps()
  end

  @doc false
  def changeset(system, attrs) do
    system
    |> cast(attrs, [:name, :system_address, :x, :y, :z])
    |> validate_required([:name, :system_address, :x, :y, :z])
    |> unique_constraint(:system_address)
  end
end
