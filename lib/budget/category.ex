defmodule Budget.Category do
  use Ecto.Schema
  alias Budget.Expenditure

  schema "categories" do
    has_many :expenditures, Expenditure
    field :name, :string
    timestamps()
  end

end
