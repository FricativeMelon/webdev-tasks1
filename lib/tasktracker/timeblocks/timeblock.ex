defmodule Tasktracker.Timeblocks.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset


  schema "time_blocks" do
    field :end, :time
    field :start, :time
    belongs_to :user, Tasktracker.Accounts.User
    belongs_to :task, Tasktracker.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(timeblock, attrs) do
    timeblock
    |> cast(attrs, [:start, :end, :user_id, :task_id])
    |> validate_required([:start, :end, :user_id, :task_id])
  end
end
