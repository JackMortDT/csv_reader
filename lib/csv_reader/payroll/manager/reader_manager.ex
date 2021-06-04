defmodule CsvReader.Manager.ReaderManager do
  use GenServer

  alias CsvReader.Logic.Reader

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, [name: __MODULE__])
  end

  def process_list(list) do
    GenServer.call(__MODULE__, {:process_list, list}, 150_000)
  end

  ###
  # Server callbacks
  ###

  def init(state) do
    {:ok, state}
  end

  def handle_call({:process_list, list}, _from, state) do
    paysheets = Reader.list_to_map(list)
    {:reply, paysheets, state}
  end

end
