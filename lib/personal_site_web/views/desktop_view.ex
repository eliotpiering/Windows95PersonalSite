defmodule PersonalSiteWeb.DesktopView do
  use PersonalSiteWeb, :view

  def display_program(program = %PersonalSite.Program{type: :explorer}) do
    Phoenix.View.render(PersonalSiteWeb.ExplorerView, "index.html", %{program: program})
  end

  def display_program(program = %PersonalSite.Program{type: :markdown}) do
    Phoenix.View.render(PersonalSiteWeb.MarkdownView, "index.html", %{markdown: program.file.contents})
  end

  def display_program(program = %PersonalSite.Program{type: :music}) do
    Phoenix.View.render(PersonalSiteWeb.MusicPlayerView, "index.html", %{music_file: program.file})
  end


  # TODO this is duplicated here and in the ExplorerView
  def icon_class(%PersonalSite.Program{type: :explorer}) do
    "icon w95-folder"
  end

  def icon_class(%PersonalSite.Program{type: :music}) do
    "icon w95-music-cd"
  end

  def icon_class(%PersonalSite.Directory{}) do
    "icon w95-folder"
  end

  def icon_class(_) do
    "icon w95-text-file"
  end
end
