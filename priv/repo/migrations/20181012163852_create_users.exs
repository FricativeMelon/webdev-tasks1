defmodule Tasktracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :tasks, {:array, :string}

      timestamps()
    end

  end
end
