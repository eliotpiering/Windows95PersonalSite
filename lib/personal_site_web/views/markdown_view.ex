defmodule PersonalSiteWeb.MarkdownView do
  use PersonalSiteWeb, :view


  def render_md(markdown) do
    Earmark.as_html!(markdown) |> Phoenix.HTML.raw()
  end

end
