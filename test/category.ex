defmodule Expenditure do
  use ExUnit.Case

  alias Budget.Repo
  alias Budget.Expenditure

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

  test "can add categories to budget successfully" do

  end

  test "can add duplicate category to budget - idempotent" do

  end

  test "can remove category with no associated expenditures" do

  end

  test "can remove category with associated expenditures causing expenditures to be assigned to general category" do

  end

  test "returns error when deleting non-existent category" do

  end
end
