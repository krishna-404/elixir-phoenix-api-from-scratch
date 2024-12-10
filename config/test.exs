import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :real_deal_api, RealDealApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "real_deal_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :real_deal_api, RealDealApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "iDMW1hS9iVx8Ri1fOTbZCNdCEGdpN1JoFKH39wJeknI8UFe4e8MJIC5EOt86/hML",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :real_deal_api, :sql_sandbox, true

config :guardian, Guardian.DB,
  repo: RealDealApi.Repo,
  schema_name: "guardian_tokens",
  sweep_interval: :timer.hours(24), # Longer interval for tests
  # token_types: ["access", "refresh"],
  sweep_enabled: false  # Disable sweeper in test environment
