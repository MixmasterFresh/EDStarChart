defmodule StarChart.Data.System do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:system_address, :integer, []}
  @derive {Phoenix.Param, key: :system_address}
  schema "systems" do
    field :name, :string
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
    |> unique_constraint(:system_address, name: :primary)
  end
end
