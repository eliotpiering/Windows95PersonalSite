defmodule PersonalSiteWeb.DesktopLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(PersonalSiteWeb.DesktopView, "index.html", assigns)
  end

  def mount(%{}, socket) do
    {:ok,
     assign(socket,
       root_files: PersonalSite.Directory.root().files,
       programs: %{},
       window_infos: %{}
     )}
  end

  def handle_event("run_program", %{"path" => path}, socket) do
    {:ok, program} = PersonalSite.Program.run(path)

    {:noreply,
     assign(socket,
       programs: Map.put(socket.assigns.programs, program.pid, program),
       window_infos:
         Map.put(
           socket.assigns.window_infos,
           program.pid,
           PersonalSite.WindowInfo.new_window(program.pid, socket.assigns.window_infos)
         )
     )}
  end

  def handle_event("close_program", %{"pid" => pid}, socket) do
    # {:ok, assign(socket, pids: MapSet.delete(socket.assigns.pids, pid))}
    {:noreply,
     assign(socket,
       programs: Map.delete(socket.assigns.programs, pid),
       window_infos: Map.delete(socket.assigns.window_infos, pid)
     )}
  end

  # TODO put these in explorerLiveView
  def handle_event("explorer_open_file", %{"pid" => pid, "path" => path}, socket) do
    program = Map.get(socket.assigns.programs, pid)
    new_programs = PersonalSite.Program.execute(:open_file, program, path)
    existing_windows = socket.assigns.window_infos
    new_windows = new_programs |> Map.keys |> Enum.reduce(existing_windows, fn (pid, windows) ->
      Map.put(windows, pid, PersonalSite.WindowInfo.new_window(pid, windows))
    end)
    {:noreply,
     assign(socket,
       programs: Map.merge(socket.assigns.programs, new_programs),
       window_infos: new_windows
     )}
  end

  def handle_event("explorer_back", %{"pid" => pid}, socket) do
    program = Map.get(socket.assigns.programs, pid)
    updated_program = PersonalSite.Program.execute(:explorer_back, program)
    {:noreply, assign(socket, programs: Map.put(socket.assigns.programs, pid, updated_program))}
  end

  def handle_event("card_window_moved", value, socket) do
    moved_program =
      Map.get(socket.assigns.window_infos, value["pid"])
      |> Map.merge(%{x: value["x"], y: value["y"]})

    {:noreply,
     assign(
       socket,
       window_infos: Map.put(socket.assigns.window_infos, value["pid"], moved_program)
     )}
  end
end
