
# Dashboard

## Live Version

A live version of this dashboard can be found at: https://dashboard.michaeljopnes.co.uk

There are currently Elm & Gleam dashboards. It is easy to add more.


## For Development

Create a `config/dev.secret.exs` file with the following contents:

```
use Mix.Config

config :dashboard,
  access_token: "<your github personal access token>"
```

This file is ignored by git.

You create a personal access token here: https://github.com/settings/tokens. The token doesn't need
any permissions. It is only used to increase the rate limits on the requests to the public Github
APIs.

Then run the following commands to get set up. We don't use a database at the moment but I left it
in the default set up as it might be useful before too long.

```
mix deps.gets
mix ecto.create
mix phx.server
```
