defmodule Tasktracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false
    field :desc, :string
    field :time, :integer, default: 0
    field :title, :string
    field :user_id, :id, default: nil

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :desc, :completed, :time, :user_id])
    |> validate_required([:title, :desc, :completed, :time, :user_id])
  end
end
