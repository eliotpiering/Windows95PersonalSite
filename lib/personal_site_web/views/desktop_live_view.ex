defmodule PersonalSiteWeb.DesktopLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(PersonalSiteWeb.DesktopView, "index.html", assigns)
  end

  def mount(%{user_id: user_id}, socket) do
    case {:ok, 40} do
      {:ok, temperature} ->
        {:ok, assign(socket, temperature: temperature, user_id: user_id, open_objs: %{})}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def handle_event("open_obj", value, socket) do
    new_folder = Map.merge(initial_position(), folder_lookup(value["slug"]))
    new_folders = socket.assigns.open_objs |> Map.put(value["slug"], new_folder)
    {:noreply, assign(socket, open_objs: new_folders)}
  end

  def handle_event("close", value, socket) do
    new_folders = socket.assigns.open_objs |> Map.delete(value["slug"])
    {:noreply, assign(socket, open_objs: new_folders)}
  end

  def handle_event("card_window_moved", value, socket) do
    moved_folder = Map.merge(%{x: value["x"], y: value["y"]}, folder_lookup(value["slug"]))
    new_folders = socket.assigns.open_objs |> Map.put(value["slug"], moved_folder)
    {:noreply, assign(socket, open_objs: new_folders)}
  end

  defp initial_position() do
    %{x: 0, y: 0}
  end

  #TODO break this out to its own module with access methods and %nolder
  defp folder_lookup(slug) do
    case slug do
      "fun_projects" ->
        %PersonalSite.Folder{title: "Fun Projects", description: "Some of my past projects. Collection of partially finished ideas, games and other side projects I worked on -- mostly to learn new things."}
      "work_projects" ->
        %PersonalSite.Folder{title: "Work Projects", description: "Some descriptions of Actual Projects I've worked on.  Its a little slice of my Resume.  You can also just check out my actual resume"}
      "resume" ->
        %PersonalSite.TextFile{title: "Resume", contents: "My resume..."}

      _ ->
        %PersonalSite.Folder{title: "Unknown", description: "???"}
    end
  end
end
