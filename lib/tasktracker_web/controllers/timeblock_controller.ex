defmodule TasktrackerWeb.TimeblockController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Timeblocks
  alias Tasktracker.Timeblocks.Timeblock

  action_fallback TasktrackerWeb.FallbackController

  def index(conn, _params) do
    time_blocks = Timeblocks.list_time_blocks()
    render(conn, "index.json", time_blocks: time_blocks)
  end

  def create(conn, %{"timeblock" => timeblock_params}) do
    with {:ok, %Timeblock{} = timeblock} <- Timeblocks.create_timeblock(timeblock_params) do
      conn 
      |> put_flash(:info, "Time block added successfully.")
      |> redirect(to: Routes.task_path(conn, :show, Tasktracker.Tasks.get_task!(timeblock.task_id))) 
    end
  end

  def show(conn, %{"id" => id}) do
    timeblock = Timeblocks.get_timeblock!(id)
    render(conn, "show.json", timeblock: timeblock)
  end

  def update(conn, %{"id" => id, "timeblock" => timeblock_params}) do
    timeblock = Timeblocks.get_timeblock!(id)

    with {:ok, %Timeblock{} = timeblock} <- Timeblocks.update_timeblock(timeblock, timeblock_params) do
      render(conn, "show.json", timeblock: timeblock)
    end
  end

  def delete(conn, %{"id" => id}) do
    timeblock = Timeblocks.get_timeblock!(id)

    with {:ok, %Timeblock{}} <- Timeblocks.delete_timeblock(timeblock) do
      conn
      |> put_flash(:info, "Time block deleted successfully.")
      |> redirect(to: Routes.task_path(conn, :show, Tasktracker.Tasks.get_task!(timeblock.task_id)))
    end
  end
end
