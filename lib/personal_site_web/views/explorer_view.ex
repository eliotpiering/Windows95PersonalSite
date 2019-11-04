defmodule PersonalSiteWeb.ExplorerView do
  use PersonalSiteWeb, :view

  # TODO this is duplicated here and in the DesktopView
  def icon_class(%PersonalSite.Directory{}) do
    "icon w95-folder"
  end

  def icon_class(_) do
    "icon w95-text-file"
  end
end
