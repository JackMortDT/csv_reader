defmodule CsvReaderWeb.ScanView do
  use CsvReaderWeb, :view

  alias CsvReader.Logic.Reader

  def files_select_options(options) do
    for option <- options, do: {option, option}
  end

  def render("export.xlsx", %{file: file}) do
    Reader.read_file("./files/#{file}")
  end
end
