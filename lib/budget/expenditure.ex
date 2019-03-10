defmodule Budget.Expenditure do
  use Ecto.Schema
  alias Budget.Category

  schema "expenditures" do
    belongs_to :category, Category
    field :amount, :float
    field :description, :string
    timestamps()
  end

end
