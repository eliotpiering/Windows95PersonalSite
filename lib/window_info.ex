defmodule PersonalSite.WindowInfo do
  defstruct x: 0, y: 0, z: 0

  def new_window(pid, current_windows) do
    existing_window = Map.get(current_windows, pid)

    if existing_window do
      existing_window
    else
      window_number = current_windows |> Map.keys() |> length()
      %PersonalSite.WindowInfo{x: 0, y: 0, z: window_number}
    end
  end
end
