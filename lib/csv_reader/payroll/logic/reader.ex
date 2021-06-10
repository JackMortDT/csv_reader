defmodule CsvReader.Logic.Reader do

  alias CsvReader.Repository.Payroll

  @doc """
    Read sql file and get ids from that

    ## Example

    iex> Reader.get_ids_from_sql("./sql/2020Enero.xlsx.sql")

    "1, 2, 3, 4, 5"
  """
  def get_ids_from_sql(path) do
    File.read!(path)
    |> String.replace(~r/[^\d]/, "")
    |> String.codepoints()
    |> Enum.chunk_every(6)
    |> Enum.map(&Enum.join/1)
  end

  @doc """
    Build new sql file with list of all ids

    ## Example

    iex> Reader.build_new_sql_update("./sql/2020Enero.xlsx.sql", "2020Enero")
    :ok
  """
  def build_new_sql_update(path, file_name) do
    ids = path |> get_ids_from_sql() |> Enum.join(",\n")
    << y::8, e::8, a::8, r::8, _::binary >> = file_name
    year = <<y>> <> <<e>> <> <<a>> <> <<r>>
    query = "\n -- #{file_name} \n UPDATE paysheet SET status = 'ACTIVE' WHERE ID in (#{ids}); \n"
    File.write!("./oracle/#{year}.sql", query, [:append])
  end

  @doc """
    Read xlsx file and get a list of values

    ## Example

    iex> Reader.read("./files/2020Enero.xlsx")

    [["", "", ""], ["", "", ""], ["", "", ""]]
  """
  def read(path) do
    {:ok, file} = path
    |> Xlsxir.multi_extract(0)

    file
    |> Xlsxir.get_list()
  end

  @doc """
    Read file from a specific path and get all registers

    ## Example

    iex> Reader.read_file("./files/2020EneroTest.xlsx", "2020EneroTest.xlsx")

    :ok
  """
  def read_file(path, file_name) do
    path
    |> read()
    |> Enum.map(fn n -> Task.async(fn -> list_to_map(n) end) end)
    |> Enum.map(fn n -> Task.await(n, :infinity) end)
    |> List.flatten()
    |> create_update_query()
    |> add_query_to_file(file_name)
  end

  def list_to_map(list) do
    [year, payment_term, division, campus, program, modality,
    term_code, teacher, enrollment_employee, enrollment_teacher,
    company, payment_type, crn, course_code, course_number, course_desc,
    begin_date, end_date, begin_hour, end_hour, minutes, l, m, x, j, v, s, d,
    factor, number_of_sessions, fee, sessions_fee, absences, absences_fee,
    delayments, delayments_fee, substitutions, subtitutions_fee, net_hours, net_amount] = list
    %{
      year: float_to_binary(year),
      payment_term: payment_term,
      division: division,
      campus: campus,
      program: program,
      modality: modality,
      term_code: float_to_binary(term_code),
      teacher: teacher,
      enrollment_employee: enrollment_employee,
      enrollment_teacher: enrollment_teacher,
      company: company,
      payment_type: payment_type,
      crn: float_to_binary(crn),
      course_code: course_code,
      course_number: course_number,
      course_desc: course_desc,
      begin_date: begin_date,
      end_date: end_date,
      begin_hour: begin_hour,
      end_hour: end_hour,
      minutes: minutes,
      l: l,
      m: m,
      x: x,
      j: j,
      v: v,
      s: s,
      d: d,
      factor: factor,
      number_of_sessions: number_of_sessions,
      fee: fee,
      sessions_fee: sessions_fee,
      absences: absences,
      absences_fee: absences_fee,
      delayments: delayments,
      delayments_fee: delayments_fee,
      substitutions: substitutions,
      subtitutions_fee: subtitutions_fee,
      net_hours: net_hours,
      net_amount: net_amount
    }
    |> get_paysheets()
  end

  defp get_paysheets(params) do
    Payroll.get_paysheet_by_params(params)
    |> get_max()
  end

  defp float_to_binary(number) when is_float(number) do
    :erlang.float_to_binary(number, [decimals: 0])
  end
  defp float_to_binary(number) when is_integer(number) do
    Integer.to_string(number)
  end
  defp float_to_binary(string) do
    string
  end

  defp create_update_query(paysheet_list) do
    Enum.map(paysheet_list, fn paysheet ->
      "UPDATE paysheet SET status = 'ACTIVE' WHERE ID = #{paysheet.id}; \n"
    end)
  end

  def add_query_to_file(query_list, file_name) do
    File.write("./sql/#{file_name}.sql", "#{query_list}\n")
  end

  def max_paysheet(paysheet_a, paysheet_b) do
    cond do
      paysheet_a.updated_at > paysheet_b.updated_at -> paysheet_a
      paysheet_b.updated_at > paysheet_a.updated_at -> paysheet_b
      true -> paysheet_a
    end
  end

  def get_max([]), do: []
  def get_max([a]), do: a
  def get_max([head | tail]), do: Enum.reduce(tail, head, &max_paysheet/2)

end
