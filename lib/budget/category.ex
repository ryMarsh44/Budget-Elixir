defmodule Budget.Category do
  use Ecto.Schema
  alias Budget.Category
  alias Budget.Expenditure
  alias Budget.Repo

  schema "categories" do
    has_many :expenditures, Expenditure
    field :name, :string
    timestamps()
  end


end

defmodule Budget.CategoryService do

  import Ecto.Query
  alias Budget.Repo
  alias Budget.Category

  def add(nil), do: nil

  def add([]), do: nil

  @spec add(List.t) :: [%Category{}]
  def add([head | tail]) do
    [add(head)] ++ add(tail)
  end

  @spec add(String.t) :: %Category{}
  def add(name) do
    %Category{name: name} |> Repo.insert
  end

  def remove(name) do
    Enum.map get(name), &(Repo.delete!(&1))
  end

  def get(name) do
    Repo.all(from c in Category, where: c.name == ^name, select: c)
  end

  def list() do
    Enum.map Repo.all(from c in Category, select: c), &(&1.name)
  end
end
