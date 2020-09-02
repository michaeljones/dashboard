# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule DashboardWeb.Markdown do
  # Protect against handling nil
  def as_html(nil) do
    Phoenix.HTML.raw("")
  end

  def as_html(text) do
    escaped =
      text
      |> HtmlSanitizeEx.strip_tags()

    case Earmark.as_html(escaped, gfm: true, breaks: true) do
      {:ok, html, _error} -> Phoenix.HTML.raw(html)
      {:error, _html, _error} -> Phoenix.HTML.raw(escaped)
    end
  end
end
