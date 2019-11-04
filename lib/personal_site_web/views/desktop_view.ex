defmodule PersonalSiteWeb.DesktopView do
  use PersonalSiteWeb, :view

  def show_process(slug, %PersonalSite.Folder{} = folder) do
    Phoenix.View.render(PersonalSiteWeb.FolderView, "index.html", %{title: folder.title, folder: folder, slug: slug})
  end

  def show_process(slug, %PersonalSite.TextFile{} = file) do
    Phoenix.View.render(PersonalSiteWeb.TextFileView, "index.html", %{title: file.title, file: file, slug: slug})
  end

  def display_process(pid) do
    dir = PersonalSite.Program.value(pid)
    Phoenix.View.render(PersonalSiteWeb.ExplorerView, "index.html", %{cwd: dir})
  end

  def display_program(program = %PersonalSite.Program{type: :explorer}) do
    Phoenix.View.render(PersonalSiteWeb.ExplorerView, "index.html", %{program: program})
  end

  def display_program(program = %PersonalSite.Program{type: :markdown}) do
    Phoenix.View.render(PersonalSiteWeb.MarkdownView, "index.html", %{markdown: program.file.contents})
  end

  # TODO this is duplicated here and in the ExplorerView
  def icon_class(%PersonalSite.Program{type: :explorer}) do
    "icon w95-folder"
  end

  def icon_class(_) do
    "icon w95-text-file"
  end


end
