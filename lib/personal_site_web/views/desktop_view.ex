defmodule PersonalSiteWeb.DesktopView do
  use PersonalSiteWeb, :view

  def obj_render(slug, %PersonalSite.Folder{} = folder) do
    Phoenix.View.render(PersonalSiteWeb.FolderView, "index.html", %{title: folder.title, folder: folder, slug: slug})
  end

  def obj_render(slug, %PersonalSite.TextFile{} = file) do
    Phoenix.View.render(PersonalSiteWeb.TextFileView, "index.html", %{title: file.title, file: file, slug: slug})
  end


  # def obj_render(slug, obj) do
  #   window_header(slug, obj) |> window_body(slug, obj) |> window_footer(slug, obj) |> raw
  # end

  defp window_header(slug, obj) do
    ~s(
      <div class="card card-tertiary">
        <div class="card-header">
          <span class="icon icon-xs w95-folder"></span>
          <span class="ml-4">#{obj.title}</span>
        </div>
      <div class="card-body">
    )
  end

  defp window_body(html, slug, obj = %PersonalSite.Folder{}) do
    html <> PersonalSite.Folder.body_html(slug, obj)
  end

  defp window_body(html, slug, obj = %PersonalSite.TextFile{}) do
    html <> PersonalSite.TextFile.body_html(slug, obj)
  end

  defp window_footer(html, slug, obj) do
    html <> ~s(
      <div class="d-flex mt-3">
        <button phx-click="close" phx-value-slug="#{slug}" class="btn btn-sm btn-primary" type="button">
          <span class="btn-text">Cancel</span>
        </button>
      </div>
      </div>
      </div>
    )
  end

end
