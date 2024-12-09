# RealDealApi

## CLI commands

### Create a new Phoenix API project:

```
mix phx.new real_deal_api --app real_deal_api --database postgres --no-live --no-assets --no-html --no-dashboard --no-mailer --binary-id --no-esbuild --no-gettext --no-tailwind
```

### Go to project folder:

```
cd real_deal_api
```
### Configure your database

Goto (config/dev.exs)[./config/dev.exs] and configure your database.

### Install & setup dependencies:

Can also use `mix deps.get` to install dependencies

```
mix setup
```

### Create database:

```
mix ecto.create
```

### Start Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
