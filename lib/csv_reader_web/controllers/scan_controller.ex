defmodule CsvReaderWeb.ScanController do
  use CsvReaderWeb, :controller

  alias CsvReader.Logic.Reader

  def index(conn, _params) do
    options = File.ls!("./files/")
    conn
    |> assign(:options, options)
    |> render("index.html")
  end

  def export_file(conn, params) do
    Reader.read_file("./files/#{params["file"]}")
    file = File.read!("./files/updates.sql")
    conn
    |> put_resp_content_type("text/sql")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=updates.sql")
    |> send_resp(200, file)
  end
end
