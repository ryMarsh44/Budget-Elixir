defmodule BudgetDBTest do
  use ExUnit.Case

  alias Budget.Repo
  alias Budget.Expenditure
  alias Budget.Category

  import Ecto.Query

  setup_all do
    {:ok, pid} = Budget.start(nil, nil)
    {:ok, [pid: pid]}
  end

  setup do
    on_exit fn ->
      Repo.delete_all(Expenditure)
      Repo.delete_all(Category)
    end
  end

  test "can read and write to budget db using expenditures and categories tables" do
    # assert we can insert Category
    {:ok, rent_category} = %Category{name: "rent"} |> Repo.insert
    Repo.insert(%Category{name: "gas"})
    Repo.insert(%Category{name: "food"})

#    assert List("rent", "gas", "food") == Category |> select([categories], categories.name) |> where
    assert ["rent", "gas", "food"] == Category |> select([category], category.name) |> Repo.all

    my_description = "My Rent"
    {:ok, expenditure} = %Expenditure{amount: 345.0, category_id: rent_category.id, description: my_description} |> Repo.insert
    [345.0] = Expenditure |> select([expenditure], expenditure.amount) |> Repo.all

    # assert we can insert Expenditure
    Repo.insert(%Expenditure{amount: 3.0, category_id: rent_category.id, description: my_description})
    Repo.insert(%Expenditure{amount: 1.0, category_id: rent_category.id, description: my_description})
    Repo.insert(%Expenditure{amount: 4.0, category_id: rent_category.id, description: my_description})
    assert List.duplicate(my_description, 4) == Expenditure
                                             |> select([expenditure], expenditure.description)
                                             |> where([expenditure], expenditure.description == ^my_description)
                                             |> Repo.all


    # ... and one more expenditure for good measure
    {:ok, general_category} = %Category{name: "general"} |> Repo.insert
    cost = 97879.0
    {:ok, expenditure} = %Expenditure{amount: cost, category_id: general_category.id, description: ""} |> Repo.insert
    assert [cost] == Expenditure
                     |> select([expenditure], expenditure.amount)
                     |> where([expenditure], expenditure.amount >= 1000.0)
                     |> Repo.all
  end
end