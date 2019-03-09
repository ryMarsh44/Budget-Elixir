defmodule Budget.Expenditure do
  use Ecto.Schema

  schema "expenditure" do
    field :key, :string
    field :amount, :float
    field :category, :string
    field :metadata, :string
    timestamps()
  end
end