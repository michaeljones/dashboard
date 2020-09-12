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

    div_class =
      if quiet do
        "inline mb-2 mx-2"
      else
        "block sm:inline mb-2"
      end

    ~E"""
      <span class="<%= div_class %>">
       <%= link repo["name"],
        to: "https://github.com/#{repo["name"]}",
        class: class <> " px-2 py-1 rounded text-mid-blue -mx-2 sm:mx-0"
       %>
      </span>
    """
  end

  def release_link(release) do
    Link.link(release["tag_name"], to: "#{release["html_url"]}", class: "text-mid-blue")
  end

  def issue_link(issue) do
    Link.link("##{issue["number"]} #{issue["title"]}",
      to: issue["html_url"],
      class: "text-mid-blue"
    )
  end

  def issue_number_link(issue) do
    Link.link("#" <> Integer.to_string(issue["number"]),
      to: issue["html_url"],
      class: "text-mid-blue"
    )
  end

  def issue_title_link(issue) do
    Link.link(issue["title"], to: issue["html_url"], class: "text-mid-blue")
  end

  def pr_link(pr) do
    Link.link("##{pr["number"]} #{pr["title"]}",
      to: pr["html_url"],
      class: "text-mid-blue"
    )
  end

  def pr_number_link(pr) do
    Link.link("#" <> Integer.to_string(pr["number"]), to: pr["html_url"], class: "text-mid-blue")
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

  def push_link(push, repo) do
    text =
      if push["distinct_size"] == 1 do
        "1 New Commit"
      else
        Integer.to_string(push["distinct_size"]) <> " New Commits"
      end

    before_short = String.slice(push["before"], 0, 10)
    head_short = String.slice(push["head"], 0, 10)

    url = "https://github.com/#{repo["name"]}/compare/#{before_short}...#{head_short}"

    Link.link(text, to: url, class: "text-mid-blue truncate")
  end

  def colon() do
    # Must be without surrounding spaces to be properly inlined into the template
    ~E[<span class="hidden sm:inline">:</span>]
  end

  def markdown(text) do
    ~E"""
      <div class="mt-2 markdown">
        <%= DashboardWeb.Markdown.as_html(text) %>
      </div>
    """
  end

  def unhandled(entry) do
    ~E"""
      <li class="base-entry border-secondary">
        <div class="sm:inline"><%= repo_link entry["repo"] %></div>
        <div class="sm:inline"><%= entry["type"] %></div>
        <div class="hidden sm:inline">-</div>
        <div class="sm:inline"><%= actor_link entry["actor"] %> - <%= Timex.from_now(entry["datetime"]) %></div>
      </li>
    """
  end

  def dump(entry) do
    ~E"<pre><%= Kernel.inspect(entry, pretty: true) %></pre>"
  end
end
