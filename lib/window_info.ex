defmodule PersonalSite.WindowInfo do
  defstruct x: 0, y: 0, z: 0, minimized: false

  def new_window(pid, current_windows) do
    existing_window = Map.get(current_windows, pid)

    if existing_window do
      existing_window
    else
      window_number = current_windows |> Map.keys() |> length()
      %PersonalSite.WindowInfo{x: 0, y: 0, z: window_number}
    end
  end

  def minimize(pid, current_windows) do
    IO.inspect(current_windows, label: "current win")
    IO.inspect(pid, label: "pid")
    existing_window = Map.get(current_windows, pid)

    if existing_window.minimized do
      move_window_to_front(pid, current_windows)
    else
      %{pid => %{existing_window | minimized: true}}
    end
  end

  defp move_window_to_front(pid, current_windows) do
    window_count = current_windows |> Map.keys |> length()
    current_z = Map.get(current_windows, pid).z

    Enum.reduce(current_windows, current_windows, fn {p, window_info}, windows ->
      cond do
        p == pid ->
          %{windows | p => %{window_info | z: window_count - 1, minimized: false}}

        window_info.z > current_z ->
          %{windows | p => %{window_info | z: window_info.z - 1}}

        true ->
          windows
      end
    end)
  end
end
