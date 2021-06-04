defmodule CsvReaderWeb.ScanController do
  use CsvReaderWeb, :controller

  def index(conn, _params) do
    options = File.ls!("./files/")
    IO.inspect options
    conn
    |> assign(:options, options)
    |> render("index.html")
  end

  def export_file(conn, params) do
    conn
    |> render("export.xlsx", %{params: params})
  end
end
