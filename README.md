# RealDealApi
Following the tutorial from [Elixir API: Password Authentication](https://www.youtube.com/watch?v=LGY_eILc8Ks&list=PL2Rv8vpZJz4zM3Go3X-dda478p-6xrmEl)

Same in blog format: [Elixir API: Password Authentication Blog](https://medium.com/@arnoldchris262/how-to-build-scalable-production-ready-apis-in-phoenix-elixir-part-1-bdc5d7981d83)

Also taking inspiration from [Elixir API from scratch](https://intercaetera.com/posts/elixir-api-from-scratch/)

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

Goto [config/dev.exs](./config/dev.exs) and configure your database.

### Add .elixir_ls/ to .gitignore

```
echo ".elixir_ls/" >> .gitignore
```

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

```
mix phx.server
```
You can also start inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000/api`](http://localhost:4000/api) from your browser.

### Run tests:

```
mix test
```
There will be 3 tests all should pass.

### Install mix_test_watch dependency:

```
mix deps.get
```

### Run tests and watch for changes:

```
mix test.watch
```

### Remove .elixir_ls directory tracking in git:

```
git rm -r --cached .elixir_ls
```

### Create Account Context, Schema, and Migration:

```
mix phx.gen.json Accounts Account accounts email:string hashed_password:string
```

### Create User Context, Schema, and Migration:

```
mix phx.gen.json Users User users account_id:references:accounts full_name:string gender:string biography:text
```

### Run migrations:

```
mix ecto.migrate
```

---
Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
