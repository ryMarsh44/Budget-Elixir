defmodule Expenditure do
  use ExUnit.Case

  alias Budget.Repo
  alias Budget.Expenditure
  alias Budget.ExpenditureService
  alias Budget.Category
  alias Budget.CategoryService

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

  test "can successfully add expenditures" do
    expense1 = 1.0
    {:ok, expense} = ExpenditureService.add(expense1)
    assert expense.description == ""
    assert expense.amount == expense1

    expense_list = [{2.0, "Car"}, {5.2, "Food", "Random"}]
    [{:ok, second} | [{:ok, third} | _]] = ExpenditureService.add_expenses(expense_list)
    assert second.amount == 2.0
    assert third.description == "Random"
  end

  test "can successfully remove expenditures" do
    assert [] == ExpenditureService.remove(99999999)

    expense = 9999999.1
    {:ok, expense} = ExpenditureService.add(expense)
    [deleted_expense | _] = ExpenditureService.remove(expense.id)
    assert expense.id == deleted_expense.id
    assert [] == ExpenditureService.remove(expense.id)

    expense_list = [{2.0, "Car"}, {5.2, "Food", "Random"}]
    [{:ok, second} | [{:ok, third} | _]] = ExpenditureService.add_expenses(expense_list)
    assert [] != ExpenditureService.get(third.id)

    [remove_2 | [remove_3 | _]] = ExpenditureService.remove([second.id, third.id])
    assert second.id == remove_2.id
    assert third.id == remove_3.id
    assert [] == ExpenditureService.get(third.id)
  end

  test "can successfully filter expenditures" do
    expense_list = [{2.0, "Car"}, {5.2, "Food", "Random"}, {3.1, "Car"}, {1.0, "Car"}, {8.9, "Food"},{8.0, "General"}]
    [{:ok, _} | _] = ExpenditureService.add_expenses(expense_list)
    assert 6.1 == ExpenditureService.category_expenses("Car")
    assert 14.1 == ExpenditureService.category_expenses(["Car", "General"])
  end

  test "can calculate total expenses" do
    expense_list = [{1.0}, {2.0, "Car"}, {5.2, "Food", "Random"}]
    [{:ok, second} | [{:ok, third} | _]] = ExpenditureService.add_expenses(expense_list)
    assert 8.2 == ExpenditureService.total_expenses()
  end

#  test "can import csv file and add the expenditures" do
#
#  end
#
#  test "fails properly with invalid csv file format" do
#
#  end
#
#  test "fails properly with invalid path" do
#
#  end
#
#  test "can successfully export expenditures into csv" do
#
#  end

end