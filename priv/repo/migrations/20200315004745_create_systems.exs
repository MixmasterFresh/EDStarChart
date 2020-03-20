defmodule StarChart.Repo.Migrations.CreateSystems do
  use Ecto.Migration

  def change do
    create table(:systems, primary_key: false) do
      add :name, :string
      add :system_address, :integer, primary_key: true
      add :x, :float
      add :y, :float
      add :z, :float

      timestamps()
    end

    create index(:systems, [:x, :z, :y])
  end
end
