defmodule CsvReader.Logic.Reader do

  alias CsvReader.Repository.Payroll

  @doc """
    Read file from a specific path and get all registers

    ## Example

    iex> Reader.read_file("./files/2020EneroTest.xlsx")

    [%Paysheet{}, %Paysheet{}, %Paysheet{}, %Paysheet{}]
  """
  def read_file(path) do
    {:ok, file} = path
    |> Xlsxir.multi_extract(0)

    file |> Xlsxir.get_list()
    |> Enum.map(&list_to_map/1)
    |> List.flatten()
    |> create_update_query()
    |> add_query_to_file()
  end

  defp list_to_map(list) do
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
      "UPDATE paysheet SET status = 'ACTIVE' WHERE ID = #{paysheet.id};"
    end)
  end

  defp add_query_to_file(query) do
    File.write("./files/updates.sql", "#{query} \n", [:append])
  end
end
