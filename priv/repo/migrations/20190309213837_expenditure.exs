defmodule Budget.Repo.Migrations.Expenditure do
  use Ecto.Migration

  def change do
    create table(:expenditures) do
      add :category_id, references(:categories)
      add :amount, :float
      add :description, :string
      timestamps()
    end

  end
end
