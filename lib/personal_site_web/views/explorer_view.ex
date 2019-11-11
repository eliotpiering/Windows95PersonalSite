defmodule PersonalSiteWeb.ExplorerView do
  use PersonalSiteWeb, :view

  def program_row(_, link = %PersonalSite.ExternalLink{}) do
    """
    <tr>
      <td>
        <a href="#{link.url}" target="_blank">
          <span class="#{link.icon}"></span>
        </a>
      </td>

      <td>
        <a href="#{link.url}" target="_blank">
          #{link.name}
        </a>
      </td>
    </tr>
    """
    |> Phoenix.HTML.raw()
  end

  def program_row(program, file) do
    """
    <tr phx-click="explorer_open_file"
    phx-value-path="#{file.path }"
    phx-value-pid="#{program.pid }">
      <td><span class="#{icon_class(file)}"></span></td>
      <td>#{file.name}</td>
    </tr>
    """
    |> Phoenix.HTML.raw()
    
  end

  # TODO this is duplicated here and in the DesktopView
  def icon_class(%PersonalSite.Directory{}) do
    "icon w95-folder"
  end

  def icon_class(%PersonalSite.MusicFile{}) do
    "icon w95-music-cd"
  end

  def icon_class(_) do
    "icon w95-text-file"
  end
end
