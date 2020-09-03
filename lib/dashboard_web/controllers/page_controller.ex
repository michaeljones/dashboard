defmodule DashboardWeb.PageController do
  use DashboardWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show_gleam(conn, _params) do
    repositories = [
      "gleam-lang/gleam",
      "gleam-lang/stdlib",
      "gleam-lang/bitwise",
      "gleam-lang/otp",
      "gleam-lang/http",
      "gleam-lang/httpc",
      "gleam-lang/elli",
      "gleam-lang/cowboy",
      "gleam-lang/plug",
      "gleam-experiments/elli",
      "gleam-experiments/crypto",
      "gleam-experiments/simple_json",
      "gleam-experiments/pgo",
      "gleam-experiments/cowboy",
      "gleam-experiments/plug",
      "gleam-experiments/time"
    ]

    list_repositories(conn, "Gleam", repositories)
  end

  def show_elm(conn, _params) do
    repositories = [
      "elm/browser",
      "elm/bytes",
      "elm/compiler",
      "elm/core",
      "elm/file",
      "elm/html",
      "elm/http",
      "elm/json",
      "elm/parser",
      "elm/project-metadata-utils",
      "elm/random",
      "elm/regex",
      "elm/svg",
      "elm/time",
      "elm/url",
      "elm/virtual-dom",
      "elm-community/array-extra",
      "elm-community/basics-extra",
      "elm-community/dict-extra",
      "elm-community/easing-functions",
      "elm-community/graph",
      "elm-community/html-extra",
      "elm-community/intdict",
      "elm-community/json-extra",
      "elm-community/list-extra",
      "elm-community/list-split",
      "elm-community/maybe-extra",
      "elm-community/random-extra",
      "elm-community/result-extra",
      "elm-community/string-extra",
      "elm-community/typed-svg",
      "elm-community/undo-redo",
      "elm-explorations/benchmark",
      "elm-explorations/linear-algebra",
      "elm-explorations/markdown",
      "elm-explorations/test",
      "elm-explorations/webgl",
      "rtfeldman/elm-css",
      "mdgriffith/elm-ui"
    ]

    list_repositories(conn, "Elm", repositories)
  end

  defp list_repositories(conn, list_name, repositories) do
    access_token = Application.get_env(:dashboard, :access_token)
    client = Tentacat.Client.new(%{access_token: access_token})

    result =
      repositories
      |> Parallel.map(fn repository ->
        repository_path = "repos/#{repository}/events"

        {_, output} =
          Cachex.fetch(
            :dashboard_cache,
            repository_path,
            fn key -> fetch_from_github(client, key) end,
            ttl: :timer.hours(1)
          )

        output
      end)
      |> Enum.concat()
      |> Enum.sort(&(NaiveDateTime.compare(&1["datetime"], &2["datetime"]) == :gt))

    repositories_display =
      repositories
      |> Enum.sort()
      |> Enum.intersperse(", ")
      |> Enum.join("")

    render(conn, "list.html",
      list_name: list_name,
      repositories: Enum.sort(repositories),
      repositories_display: repositories_display,
      result: result
    )
  end

  defp fetch_from_github(client, repository_path) do
    IO.puts("Fetching #{repository_path}")
    {_status, output, _response} = Tentacat.get(repository_path, client)

    value =
      output
      |> Enum.map(fn entry ->
        Map.put(entry, "datetime", NaiveDateTime.from_iso8601!(entry["created_at"]))
      end)
      |> Enum.filter(&(&1["type"] not in ["WatchEvent", "ForkEvent"]))

    {:commit, value}
  end
end
