defmodule Tasktracker.Repo.Migrations.CreateTimeBlocks do
  use Ecto.Migration

  def change do
    create table(:time_blocks) do
      add :start, :time
      add :end, :time
      add :task_id, references(:tasks, on_delete: :nothing)

      timestamps()
    end

    create index(:time_blocks, [:task_id])
  end
end
