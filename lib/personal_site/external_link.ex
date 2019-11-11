defmodule PersonalSite.ExternalLink do
  defstruct name: "", url: "", icon: "fab fa-internet-explorer fa-2x"

  def new(actual_path) do
    data = File.read!(actual_path) |> Jason.decode!()

    %PersonalSite.ExternalLink{
      name: Path.basename(actual_path),
      url: Map.get(data, "url"),
      icon: Map.get(data, "icon") || "fab fa-internet-explorer fa-2x"
    }
  end
end
