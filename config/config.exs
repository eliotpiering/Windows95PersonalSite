# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :personal_site,
  ecto_repos: [PersonalSite.Repo]

# Configures the endpoint
config :personal_site, PersonalSiteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CPR8EW7yfSNdJTW3/d/ECMCntm8/BTYEh0hhUA0TP48weRjMydoawafYIeCi54VI",
  render_errors: [view: PersonalSiteWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PersonalSite.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "94xKfEKy+VN0CJIyvGw+qDESQz6sCHkA"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
