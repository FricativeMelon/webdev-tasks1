defmodule Tasktracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :name, :string
    field :manager_id, :id, default: nil
    has_many :time_blocks, Tasktracker.Timeblocks.Timeblock

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :manager_id])
    |> validate_required([:name, :manager_id])
  end
end
