defmodule Snitch.Data.Model.User do
  @moduledoc """
  User API
  """
  use Snitch.Data.Model
  alias Snitch.Data.Schema.User, as: UserSchema

  @spec create(map) :: {:ok, UserSchema.t()} | {:error, Ecto.Changeset.t()}
  def create(query_fields) do
    QH.create(UserSchema, query_fields, Repo)
  end

  @spec update(map, UserSchema.t()) :: {:ok, UserSchema.t()} | {:error, Ecto.Changeset.t()}
  def update(query_fields, instance) do
    QH.update(UserSchema, query_fields, instance, Repo)
  end

  @spec delete(non_neg_integer) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete(id) do
    with %UserSchema{} = user <- get(id) |> Repo.preload(:orders),
         {:ok, _} = delete_response <- UserSchema.delete_changeset(user, %{}) |> Repo.delete() do
      delete_response
    else
      _ ->
        {:error, "error deleting user"}
    end
  end

  @spec get(map | non_neg_integer) :: UserSchema.t() | nil
  def get(query_fields_or_primary_key) do
    QH.get(UserSchema, query_fields_or_primary_key, Repo)
  end

  @spec get_all() :: [UserSchema.t()]
  def get_all, do: Repo.all(UserSchema)

  @spec get_username(UserSchema.t()) :: String.t()
  def get_username(user) do
    if is_nil(user), do: nil, else: user.first_name <> " " <> user.last_name
  end
end
