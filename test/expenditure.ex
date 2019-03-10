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
    end
  end

  test ""
end