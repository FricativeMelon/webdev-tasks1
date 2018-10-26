defmodule Tasktracker.Timeblocks.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset


  schema "time_blocks" do
    field :end, :time
    field :start, :time
    field :task_id, :id

    timestamps()
  end

  @doc false
  def changeset(timeblock, attrs) do
    timeblock
    |> cast(attrs, [:start, :end])
    |> validate_required([:start, :end])
  end
end
