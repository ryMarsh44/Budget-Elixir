defmodule Expenditure do
  use ExUnit.Case

  alias Budget.Repo
  alias Budget.Expenditure
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

  test "can add categories to budget successfully" do
    first_category = "One"
    {:ok, category} = CategoryService.add(first_category)
    assert category.name == first_category


    category_list = ["two", "three", "four"]
    [{:ok, second} | _] = CategoryService.add(category_list)
    assert second.name == "two"
  end

  test "can add duplicate category to budget - idempotent" do
    duplicate = "duplicate"
    {:ok, category} = CategoryService.add(duplicate)
    {:ok, category} = CategoryService.add(duplicate)

  end

  test "can remove category with no associated expenditures" do
    remove = "remove"
    {:ok, remove_category} = CategoryService.add(remove)

    [test_removed | _ ] = CategoryService.remove(remove)
    assert test_removed.name == remove

  end

  test "can see all categories" do
    Repo.delete_all(Category)
    assert [] == CategoryService.list()

    category_list = ["two", "three", "four"]
    CategoryService.add(category_list)

    assert category_list == CategoryService.list()

    [remove_two | test_after_remove] = category_list
    CategoryService.remove(remove_two)

    assert test_after_remove == CategoryService.list()
  end

  test "can remove category with associated expenditures causing expenditures to be assigned to general category" do

  end

  test "returns empty list when deleting non-existent category" do
    assert [] == CategoryService.remove("NOT HERE")
  end

  test "can get categories" do
    assert [] = CategoryService.get("NOT HERE")

    first_category = "One"
    {:ok, category} = CategoryService.add(first_category)
    [test_category | _] = CategoryService.get(first_category)
    assert test_category.id == category.id
  end
end
