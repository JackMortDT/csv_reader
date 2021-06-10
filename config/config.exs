# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :csv_reader,
  ecto_repos: [
    CsvReader.Repo,
    CsvReader.OracleRepo
  ]

# Configures the endpoint
config :csv_reader, CsvReaderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iT/1WBq1LAXZRf1H7nWnwy0oG4F5+nuDGbwhU1Me6WJDlFTIbNAFbmRuA61uqv52",
  render_errors: [view: CsvReaderWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CsvReader.PubSub,
  live_view: [signing_salt: "lCRfDouA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
