use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :csv_reader, CsvReader.Repo,
  username: "root",
  password: "jack6496",
  database: "faltas_suplencias_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  queue_target: 500_000,
  queue_interval: 500_000,
  timeout: :infinity,
  handshake_timeout: 150_000,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :csv_reader, CsvReaderWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
