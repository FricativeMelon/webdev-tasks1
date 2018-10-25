defmodule TasktrackerWeb.UserController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    map = case user_params
               |> Map.fetch("manager_id") do
            {:ok, _} ->
              user_params
            :error ->
              Map.put(user_params, "manager_id", Tasktracker.Accounts.get_user_by_name("_").id)
          end
    case Accounts.create_user(map) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update_from_delete(conn, %{"id" => id, "user" => user_params}) do
    map =
      case user_params
           |> Map.fetch("manager_name") do
        {:ok, ""} ->
          user_params
          |> Map.delete("manager_name")
        {:ok, manager_name} ->
          user = Tasktracker.Accounts.get_user_by_name(manager_name)
          if user do
            user_params
            |> Map.delete("manager_name")
            |> Map.put("manager_id", user.id)
          else
            :error
          end
        :error ->
          :error
      end
    user = Accounts.get_user!(id)
    case map do
      :error ->
        conn
        |> put_flash(:error, "Invalid username.")
        |> redirect(to: Routes.user_path(conn, :edit, user))
      _ ->
        Accounts.update_user(user, map)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    map =
      case user_params
           |> Map.fetch("manager_name") do
        {:ok, ""} ->
          user_params
          |> Map.delete("manager_name")
        {:ok, manager_name} ->
          user = Tasktracker.Accounts.get_user_by_name(manager_name)
          if user do
            user_params
            |> Map.delete("manager_name")
            |> Map.put("manager_id", user.id)
          else
            :error
          end
        :error ->
          :error
      end
    user = Accounts.get_user!(id)
    case map do
      :error ->
        conn
        |> put_flash(:error, "Invalid username.")
        |> redirect(to: Routes.user_path(conn, :edit, user))
      _ ->
        case Accounts.update_user(user, map) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User updated successfully.")
            |> redirect(to: Routes.user_path(conn, :show, user))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", user: user, changeset: changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    Tasktracker.Tasks.list_tasks()
    |> Enum.map(fn t -> (if Integer.to_string(t.user_id, 10) == id do
                           TasktrackerWeb.TaskController.update_from_delete(conn, %{"id" => t.id, "task" => %{"user_name" => "_"}})
                         else
                           t
                         end)
                end)
    Tasktracker.Accounts.list_users()
    |> Enum.map(fn u -> (if Integer.to_string(u.manager_id, 10) == id do
                           TasktrackerWeb.UserController.update_from_delete(conn, %{"id" => u.id, "user" => %{"manager_name" => "_"}})
                         else
                           u
                         end)
                end)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
