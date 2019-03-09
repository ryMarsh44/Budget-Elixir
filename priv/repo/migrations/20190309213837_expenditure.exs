defmodule Budget.Repo.Migrations.Expenditure do
  use Ecto.Migration

  def change do
    create table(:expenditure) do
      add :key, :string
      add :amount, :float
      add :category, :string
      add :metadata, :string
      timestamps()
    end

  end
end
