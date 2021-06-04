defmodule CsvReader.Manager.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      {Task.Supervisor, name: CsvReader.TaskSupervisor},
      {CsvReader.Manager.ReaderManager, []},
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

end
