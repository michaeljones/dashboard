defmodule DashboardWeb.View do
  use Phoenix.HTML

  alias Phoenix.HTML.Link

  def actor_link(actor) do
    Link.link(actor["login"], to: "https://github.com/#{actor["login"]}", class: "text-secondary")
  end

  def repo_link(repo, opts \\ []) do
    quiet = Keyword.get(opts, :quiet, false)

    class =
      if quiet do
        "bg-white border border-grey-6"
      else
        "bg-grey-6"
      end

    Link.link(repo["name"],
      to: "https://github.com/#{repo["name"]}",
      class: class <> " px-2 py-1 rounded text-mid-blue"
    )
  end

  def release_link(release) do
    Link.link(release["tag_name"], to: "#{release["html_url"]}", class: "text-mid-blue")
  end

  def issue_link(issue) do
    Link.link("#" <> Integer.to_string(issue["number"]),
      to: issue["html_url"],
      class: "text-mid-blue"
    )
  end

  def pr_title_link(pr) do
    Link.link(pr["title"], to: pr["html_url"], class: "text-mid-blue")
  end

  def commit_link(commit, repo) do
    first_line = commit["message"] |> String.split("\n") |> List.first()

    Link.link(first_line,
      to: "https://github.com/#{repo["name"]}/commit/#{commit["sha"]}",
      class: "text-mid-blue"
    )
  end

  def sha_link(sha, repo) do
    Link.link(String.slice(sha, 0, 10) <> "...",
      to: "https://github.com/#{repo["name"]}/commit/#{sha}",
      class: "text-mid-blue"
    )
  end

  def unhandled(entry) do
    ~E"""
      <li class="base-entry border-secondary">
        <%= repo_link entry["repo"] %> <%= entry["type"] %> - <%= Timex.from_now(entry["datetime"]) %>
      </li>
    """
  end

  def dump(entry) do
    ~E"<pre><%= Kernel.inspect(entry, pretty: true) %></pre>"
  end
end
