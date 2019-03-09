defmodule Budget.Repo do
  use Ecto.Repo, otp_app: :budget, adapter: Sqlite.Ecto2
end
