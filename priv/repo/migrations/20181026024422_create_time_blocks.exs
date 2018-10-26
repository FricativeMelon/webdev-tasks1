defmodule Tasktracker.Repo.Migrations.CreateTimeBlocks do
  use Ecto.Migration

  def change do
    create table(:time_blocks) do
      add :start, :time, null: false
      add :end, :time, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :task_id, references(:tasks, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:time_blocks, [:user_id])
    create index(:time_blocks, [:task_id])
  end
end
