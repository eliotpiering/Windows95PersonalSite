defmodule PersonalSite.Directory do
  defstruct path: "", files: [], name: ""

  def base_dir do
    # TODO this works only because edeliver BUILD_AT and local directory dir are the same
    # Probably need a better place to store these files
    Path.join(["/home", "eliot", "Develop", "personal_site", "assets", "static", "desktop"])
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
end
