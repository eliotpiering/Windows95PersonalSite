defmodule PersonalSite.Directory do
  defstruct name: "", title: "", path: "", files: []

  def root do
    %PersonalSite.Directory{
      name: "/",
      path: "/",
      title: "root",
      files: [fun_projects("/"), work_projects("/"), music("/"), resume("/"), about("/")]
    }
  end

  def lookup("/") do
    root()
  end

  def lookup(path) do
    names = String.split(path, "/", trim: true)
    {:ok, file} = find_file(root(), names)
    file
  end

  defp find_file(directory, [name | []]) do
    case Enum.find(directory.files, fn f -> f.name == name end) do
      nil ->
        {:error, "file not found"}

      file ->
        {:ok, file}
    end
  end

  defp find_file(directory, [name | names]) do
    case Enum.find(directory.files, fn f -> f.name == name end) do
      sub_dir = %PersonalSite.Directory{} ->
        find_file(sub_dir, names)

      _ ->
        {:error, "file not found"}
    end
  end

  def parent_directory("/") do
    root
  end

  def parent_directory(path) do
    path |> String.split("/", trim: true) |> List.delete_at(-1) |> Enum.join("/") |> (&<>/2).("/") |> lookup
  end

  def fun_projects(parent_path) do
    name = "fun_projects"
    path = parent_path <> name <> "/"

    %PersonalSite.Directory{
      name: name,
      title: "Fun Projects",
      files: [this_site(path)],
      path: path
    }
  end

  def work_projects(parent_path) do
    name = "work_projects"

    %PersonalSite.Directory{
      name: name,
      title: "Work Projects",
      files: [],
      path: parent_path <> name <> "/"
    }
  end

  def music(parent_path) do
    name = "music"

    %PersonalSite.Directory{
      name: name,
      title: "Music Stuff",
      files: [],
      path: parent_path <> name <> "/"
    }
  end

  def resume(parent_path) do
    name = "resume.md"

    %PersonalSite.TextFile2{
      name: name,
      contents: """
      # Windows 95'd theme website
      This website was born out of
      * Wanting to learn more pheonix, specifically pheonix live view
      * Wanting a unique personal website to showcase some of my work
      * Deep nostalgia for my first real desktop... Windows 95
      So I hatched this bizarre idea. I hope you enjoy it.  You can rearange the windows and open various directories and files.

      """,
      path: parent_path <> name <> "/"
    }
  end

  def about(parent_path) do
    name = "about.md"

    %PersonalSite.TextFile2{
      name: name,
      contents: """
      # Windows 95'd theme website
      This website was born out of
      * Wanting to learn more pheonix, specifically pheonix live view
      * Wanting a unique personal website to showcase some of my work
      * Deep nostalgia for my first real desktop... Windows 95
      So I hatched this bizarre idea. I hope you enjoy it.  You can rearange the windows and open various directories and files.

      """,
      path: parent_path <> name <> "/"
    }
  end

  def this_site(parent_path) do
    name = "this_site"
    path = parent_path <> name <> "/"

    %PersonalSite.Directory{
      name: name,
      title: "My Window95 personal site",
      files: [this_site_readme(path)],
      path: path
    }
  end

  def this_site_readme(parent_path) do
    name = "readme.md"

    %PersonalSite.TextFile2{
      name: name,
      contents: """
      # Windows 95'd theme website
      This website was born out of
      * Wanting to learn more pheonix, specifically pheonix live view
      * Wanting a unique personal website to showcase some of my work
      * Deep nostalgia for my first real desktop... Windows 95
      So I hatched this bizarre idea. I hope you enjoy it.  You can rearange the windows and open various directories and files.

      """,
      path: parent_path <> name <> "/"
    }
  end
end
