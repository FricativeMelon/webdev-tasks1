defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Tasks
  alias Tasktracker.Tasks.Task

  def index(conn, params) do
    tasks = case params do
              %{"current_user" => current_user} ->
                me = Tasktracker.Accounts.get_user!(String.to_integer(current_user))
                users = Enum.filter(Tasktracker.Accounts.list_users(), fn u -> u.manager_id == me.id end)
                Enum.filter(Tasks.list_tasks(), fn t -> Enum.any?(users,
                                                     fn u -> u.id == t.user_id end) end)
              _ ->
                Tasks.list_tasks()
            end
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    map = case task_params
               |> Map.fetch("user_id") do
            {:ok, _} ->
              task_params
            :error ->
              Map.put(task_params, "user_id", Tasktracker.Accounts.get_user_by_name("_").id)
          end
    case Tasks.create_task(map) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update_from_delete(conn, %{"id" => id, "task" => task_params}) do
    map =
      case task_params
           |> Map.fetch("user_name") do
        {:ok, ""} ->
          task_params
          |> Map.delete("user_name")
        {:ok, user_name} ->
          user = Tasktracker.Accounts.get_user_by_name(user_name)
          if user do
            task_params
            |> Map.delete("user_name")
            |> Map.put("user_id", user.id)
            |> Map.put("time", 0)
          else
            :error
          end
        :error ->
          :error
      end
    task = Tasks.get_task!(id)
    case map do
      :error ->
        conn
        |> put_flash(:error, "Invalid username.")
        |> redirect(to: Routes.task_path(conn, :edit, task))
      _ ->
        Tasks.update_task(task, map)
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    map =
      case task_params
           |> Map.fetch("user_name") do
        {:ok, ""} ->
          task_params
          |> Map.delete("user_name")
        {:ok, user_name} ->
          user = Tasktracker.Accounts.get_user_by_name(user_name)
          if user do
            task_params
            |> Map.delete("user_name")
            |> Map.put("user_id", user.id)
            |> Map.put("time", 0)
          else
            :error
          end
        :error ->
          :error
      end
    task = Tasks.get_task!(id)
    case map do
      :error ->
        conn
        |> put_flash(:error, "Invalid username.")
        |> redirect(to: Routes.task_path(conn, :edit, task))
      _ ->
        case Tasks.update_task(task, map) do
          {:ok, task} ->
            conn
            |> put_flash(:info, "Task updated successfully.")
            |> redirect(to: Routes.task_path(conn, :show, task))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", task: task, changeset: changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
