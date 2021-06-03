defmodule CsvReader.Repo do
  use Ecto.Repo,
    otp_app: :csv_reader,
    adapter: Ecto.Adapters.MyXQL
end
