defmodule DashboardWeb.View do
  use Phoenix.HTML

  alias Phoenix.HTML.Link

  def actor_link(actor) do
    Link.link(actor["login"], to: "https://github.com/#{actor["login"]}")
  end

  def repo_link(repo) do
    Link.link(repo["name"],
      to: "https://github.com/#{repo["name"]}",
      class: "bg-grey-6 px-2 py-1 rounded"
    )
  end

  def release_link(release) do
    Link.link(release["tag_name"], to: "#{release["html_url"]}")
  end

  def issue_link(issue) do
    Link.link("#" <> Integer.to_string(issue["number"]), to: issue["html_url"])
  end

  def pr_title_link(pr) do
    Link.link(pr["title"], to: pr["html_url"])
  end

  def commit_link(commit, repo) do
    Link.link(commit["message"], to: "https://github.com/#{repo["name"]}/commit/#{commit["sha"]}")
  end

  def sha_link(sha, repo) do
    Link.link(String.slice(sha, 0, 10) <> "...",
      to: "https://github.com/#{repo["name"]}/commit/#{sha}"
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
