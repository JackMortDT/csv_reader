defmodule CsvReaderWeb.ScanController do
  use CsvReaderWeb, :controller

  def index(conn, _params) do
    options = File.ls!("./files/")
    conn
    |> assign(:options, options)
    |> render("index.html")
  end

  def export_file(conn, params) do
    conn
    |> render("export.xlsx", %{file: params["file"]})
  end
end
