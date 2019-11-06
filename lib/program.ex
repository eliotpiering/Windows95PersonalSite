defmodule PersonalSite.Program do
  defstruct pid: "", title: "", file: nil, type: nil

  def run(path) do
    case PersonalSite.Directory.lookup(path) do
      file = %PersonalSite.TextFile{} ->
        {:ok,
         %PersonalSite.Program{
           title: "Markdown viewer",
           type: :markdown,
           file: file,
           pid: Ecto.UUID.generate()
         }}

      file = %PersonalSite.MusicFile{} ->
        {:ok,
         %PersonalSite.Program{
           title: "Music Player - #{file.name}",
           type: :music,
           file: file,
           pid: Ecto.UUID.generate()
         }}

      dir = %PersonalSite.Directory{} ->
        {:ok,
         %PersonalSite.Program{
           title: "Explorer - #{dir.title}",
           type: :explorer,
           file: dir,
           pid: Ecto.UUID.generate()
         }}

      _ ->
        {:error, "UNKNOWN FILE TYPE"}
    end
  end

  def execute(
        :explorer_back,
        program = %PersonalSite.Program{file: %PersonalSite.Directory{}}
      ) do
    case PersonalSite.Directory.parent_directory(program.file.path) do
      %PersonalSite.Directory{path: "/"} ->
        program

      dir = %PersonalSite.Directory{} ->
        new_program = program |> Map.put(:file, dir) |> Map.put(:title, "Explorer - #{dir.title}")
        IO.inspect(new_program, label: "asdfasdf")
        new_program
    end
  end

  def execute(
        :open_file,
        program = %PersonalSite.Program{file: %PersonalSite.Directory{}},
        path
      ) do
    case PersonalSite.Directory.lookup(path) do
      dir = %PersonalSite.Directory{} ->
        updated_program =
          program |> Map.put(:file, dir) |> Map.put(:title, "Explorer - #{dir.title}")

        %{program.pid => updated_program}

      file ->
        {:ok, new_program} = PersonalSite.Program.run(file.path)
        %{program.pid => program, new_program.pid => new_program}
    end
  end
end
