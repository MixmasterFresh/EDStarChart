# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :star_chart,
  ecto_repos: [StarChart.Repo]

# Configures the endpoint
config :star_chart, StarChartWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Jwaxwj+qE29l0WuuuUS5LKPkvP96tJQRp6/f5twQjfnwQ/MZFVInNorrL3um1MIe",
  render_errors: [view: StarChartWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [
    name: StarChart.PubSub,
    adapter: Phoenix.PubSub.Redis,
    host: System.get_env("REDIS_HOST", "localhost"),
    node_name: System.get_env("POD_NAME", "some_node")
    ],
  live_view: [signing_salt: System.get_env("SIGNING_SALT", "eGS7ZN9a")]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
