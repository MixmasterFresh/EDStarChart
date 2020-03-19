defmodule StarChart.Repo.Migrations.CreateSystems do
  use Ecto.Migration

  def change do
    create table(:systems) do
      add :name, :string
      add :system_address, :integer
      add :x, :float
      add :y, :float
      add :z, :float

      timestamps()
    end

    create index(:systems, [:x, :z, :y])
    create unique_index(:systems, :system_address)
  end
end
