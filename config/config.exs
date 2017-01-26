# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :deeplock_app,
  ecto_repos: [DeeplockApp.Repo]

# Configures the endpoint
config :deeplock_app, DeeplockApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QCPedQa/Qxkad8i5aMf+IS75eYtjPTXQ8y+d4wdDtph2hzE0DBiGADoEsEhqLnzy",
  render_errors: [view: DeeplockApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DeeplockApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
