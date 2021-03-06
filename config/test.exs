use Mix.Config

# Configure your database
config :personal_site, PersonalSite.Repo,
  username: "postgres",
  password: "postgres",
  database: "personal_site_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :personal_site, PersonalSiteWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
