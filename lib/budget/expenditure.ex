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

defmodule Budget.ExpenditureService do

  import Ecto
  import Ecto.Query
  alias Budget.Repo
  alias Budget.Expenditure
  alias Budget.CategoryService

  def add_expenses(nil), do: nil

  def add_expenses([]), do: nil

  def add_expenses([head | tail]) do
    add_helper(head) ++ add_expenses(tail)
  end

  def add(amount, category \\ "general", description \\ "") do
    id = case CategoryService.get(category) do
      [category | _] -> category.id
      [] ->
        {:ok, category} = CategoryService.add(category)
        category.id
    end

    %Expenditure{amount: amount, category_id: id, description: description} |> Repo.insert
  end

  # Todo: Make this private
  defp add_helper(expenditure) do
    e = case expenditure do
      {amount} -> add(amount)
      {amount, category} -> add(amount, category)
      {amount, category, description} -> add(amount, category, description)
    end
    [e]
  end

  def remove(nil), do: nil

  def remove([]), do: nil

  @spec remove(List.t) :: [%Expenditure{}]
  def remove([head | tail]) do
    remove(head) ++ remove(tail)
  end

  @spec remove(Integer.t) :: %Expenditure{}
  def remove(id) do
    Enum.map get(id), &(Repo.delete!(&1))
  end

  def get(id) do
    Repo.all(from c in Expenditure, where: c.id == ^id, select: c)
  end

  def list() do
    Repo.all(from c in Expenditure, select: c)
  end

  def total_expenses() do
    Enum.reduce list(), 0, fn x, acc -> x.amount + acc end
  end

  def category_expenses(nil), do: 0
  def category_expenses([]), do: 0
  def category_expenses([head | tail]) do
    category_expenses(head) + category_expenses(tail)
  end

  def category_expenses(category) do
    [category | _ ] = CategoryService.get(category)
    Enum.reduce Repo.all(assoc(category, :expenditures)), 0, fn x, acc -> x.amount + acc end
  end

end
