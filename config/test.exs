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
  pool_size: System.schedulers_online() * 2,
  ownership_timeout: :infinity

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

config :guardian, RealDealApi.Guardian,
  issuer: "real_deal_api",
  secret_key: "HNinpKh9Ne3tr8BpjCpAEh0xzCqTIG3PWsfkR2AtzvUaRIpbs6oIQ9RcmZOuFP/P",
  token_ttl: %{
    "access" => {1, :day},
    "refresh" => {30, :days}
  },
  token_verify_module: Guardian.Token.Jwt.Verify,
  allowed_drift: 2000,
  verify_issuer: true

config :guardian_db, Guardian.DB,
  repo: RealDealApi.Repo,
  schema_name: "guardian_tokens",
  sweep_interval: :timer.minutes(1),  # Shorter interval for tests
  sweep_enabled: true
