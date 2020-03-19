# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :star_chart, StarChart.Repo,
  # ssl: true,
  url: database_url,
  username: "postgres",
  port: 26257,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  parameters: [application_name: "starchart"]

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :star_chart, StarChartWeb.Endpoint,
    url: [host: System.get_env("BASE_URL", "example.com"), port: 80],
    cache_static_manifest: "priv/static/cache_manifest.json"

config :star_chart, StarChartWeb.Endpoint,
  server: true,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base
