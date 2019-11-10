defmodule PersonalSite.MusicFile do
  defstruct name: "", artist: "", url: "", path: "", album_art: "", album_title: "", album_description: ""

  def new(actual_path, internal_path) do
    name = Path.basename(actual_path)
    album_info = parse_album_info(actual_path)

    %PersonalSite.MusicFile{
      path: internal_path,
      name: name,
      url: static_path(internal_path),
      artist: Map.get(album_info, "artist"),
      album_art: static_path(Map.get(album_info, "album_art")),
      album_title: Map.get(album_info, "album_title"),
      album_description: Map.get(album_info, "album_description")
    }
  end

  defp parse_album_info(actual_path) do
    info_path = actual_path |> Path.dirname() |> Path.join(".album-info.json")

    case File.read(info_path) do
      {:ok, data} ->
        parse_album_data(data)

      _ ->
        %{"album_art" => "", "album_title" => "", "artist" => ""}
    end
  end

  defp parse_album_data(data) do
    Jason.decode!(data) |> Map.take(["album_art", "album_title", "artist", "album_description"])
  end

  defp static_path(internal_path) do
    if String.length(internal_path) > 0 do
      PersonalSiteWeb.Endpoint.static_path("/desktop/" <> internal_path)
    else
      ""
    end
  end
end
