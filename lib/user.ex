defmodule User do
  @fictional_names ["Black Panther", "Wonder Woman", "Spiderman"]

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
    |> validate_fictional_name()
  end

  def validate_fictional_name(changeset) do
    name = get_field(changeset, :name)

    if name in @fictional_names do
      changeset
    else
      add_error(changeset, :name, "is not a superhero")
    end
  end

  def set_name_if_anonymous(changeset) do
    name = get_field(changeset, :name)

    if is_nil(name) do
      put_change(changeset, :name, "Anonymous")
    else
      changeset
    end
  end

  def registration_changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> set_name_if_anonymous()
  end
end
