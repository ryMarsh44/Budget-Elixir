defmodule BudgetText do
  use ExUnit.Case

  alias Budget.Repo
  alias Budget.Expenditure

  import Ecto.Query

  setup_all do
    {:ok, pid} = Budget.start(nil, nil)
    {:ok, [pid: pid]}
  end

  setup do
    on_exit fn ->
      Repo.delete_all(Expenditure)
    end
  end

  test "can read and write to budget db using expenditure table" do
    my_key = "123"
    {:ok, expenditure} = %Expenditure{key: my_key, amount: 345.0, category: "Grocery", metadata: ""} |> Repo.insert
    [my_key] = Expenditure |> select([expenditure], expenditure.key) |> Repo.all

    # assert we can insert posts
    Repo.insert(%Expenditure{key: my_key, amount: 3.0, category: "Education", metadata: "School Loan Interest"})
    Repo.insert(%Expenditure{key: my_key, amount: 1.0, category: "Grocery", metadata: ""})
    Repo.insert(%Expenditure{key: my_key, amount: 4.0, category: "Fun", metadata: ""})
    assert List.duplicate("123", 4) == Expenditure
                                             |> select([expenditure], expenditure.key)
                                             |> where([expenditure], expenditure.key == ^my_key)
                                             |> Repo.all

    # ... and one more expenditure for good measure
    cost = 97879.0
    {:ok, expenditure} = %Expenditure{key: "777", amount: cost, category: "None", metadata: ""} |> Repo.insert
    assert [cost] == Expenditure
                     |> select([expenditure], expenditure.amount)
                     |> where([expenditure], expenditure.amount >= 1000.0)
                     |> Repo.all
  end
end