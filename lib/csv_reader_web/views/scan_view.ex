defmodule CsvReaderWeb.ScanView do
  use CsvReaderWeb, :view

  def files_select_options(options) do
    for option <- options, do: {option, option}
  end
end
