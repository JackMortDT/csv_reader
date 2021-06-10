defmodule CsvReader.OracleRepo do
  use Ecto.Repo,
    otp_app: :csv_reader,
    adapter: Ecto.Adapters.Jamdb.Oracle
end
