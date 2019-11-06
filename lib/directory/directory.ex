defmodule PersonalSite.Directory do
  defstruct path: "", files: [], name: "", title: ""

  def base_dir do
    Path.join([File.cwd!(), "assets", "static", "desktop"])
  end

  def root do
    as_personal_site_directory(base_dir())
  end

  def as_personal_site_directory(actual_file_path) do
    files =
      File.ls!(actual_file_path)
      |> Enum.map(fn file_name ->
        as_personal_site_files(Path.join(actual_file_path, file_name))
      end)

    internal_path = actual_path_to_internal_path(actual_file_path)

    %PersonalSite.Directory{
      path: "/" <> internal_path,
      files: files,
      name: Path.basename(internal_path),
      title: Path.basename(internal_path)
    }
  end

  def as_personal_site_files(actual_file_path) do
    case File.stat!(actual_file_path) do
      %File.Stat{type: :directory} ->
        as_personal_site_directory(actual_file_path)

      _ ->
        ext = Path.extname(actual_file_path)

        cond do
          ext == ".md" ->
            %PersonalSite.TextFile{
              path: actual_path_to_internal_path(actual_file_path),
              name: Path.basename(actual_file_path),
              contents: File.read!(actual_file_path)
            }

          Enum.member?([".mp3", ".wav", ".ogg", ".flac"], ext) ->
            internal_path = actual_path_to_internal_path(actual_file_path)
            name = Path.basename(actual_file_path)

            %PersonalSite.MusicFile{
              path: internal_path,
              name: name,
              title: name,
              url: PersonalSiteWeb.Endpoint.static_path("/desktop/" <> internal_path)
            }
        end
    end
  end

  def actual_path_to_internal_path(actual_path) do
    Path.relative_to(actual_path, base_dir())
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
    path
    |> String.split("/", trim: true)
    |> List.delete_at(-1)
    |> Enum.join("/")
    |> (&<>/2).("/")
    |> lookup
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
    path = parent_path <> name <> "/"

    %PersonalSite.Directory{
      name: name,
      title: "Music Stuff",
      files: music_folder_files(path),
      path: path
    }
  end

  def resume(parent_path) do
    name = "resume.md"

    %PersonalSite.TextFile{
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

    %PersonalSite.TextFile{
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

    %PersonalSite.TextFile{
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

  def music_folder_files(parent_path) do
    name = "Creatures of Habit"

    [
      %PersonalSite.MusicFile{
        path: parent_path <> name <> "/",
        name: name,
        title: name,
        artist: "Tenant",
        url: PersonalSiteWeb.Endpoint.static_path("/music/creatures-of-habit-mix-3-Tenant.wav")
      }
    ]
  end
end
