defmodule CsvReader.Logic.OracleComparator do
  import Ecto.Query, warn: false

  alias CsvReader.OracleRepo
  alias CsvReader.Model.OraclePaysheet
  alias CsvReader.Model.OracleBatchBlock
  alias CsvReader.Logic.Reader
  alias CsvReader.Repository.Payroll

  @doc """
    Makes an sql file for oracle updates

    ## Example

      iex> OracleComparator.get_sql_for_oracle("./sql/2020Enero.xlsx.sql")
      :ok
  """
  def get_sql_for_oracle(path) do
    Reader.get_ids_from_sql(path)
    |> Enum.map(fn id ->
      Task.async(fn ->
        id
        |> get_paysheet!()
        |> validate_result(id)
      end)
    end)
    |> Enum.map(fn n ->
      Task.await(n, :infinity)
    end)
    |> IO.inspect()
    |> Enum.uniq()
    |> create_sql_file()
  end

  def create_sql_file(query_list) do
    File.write("./oracle/updates.sql", "#{query_list} \n", [:append])
  end

  @doc """
    Return small return from oracle that give us data from oracle by id

    ## Example

      iex> OracleComparator.get_paysheet!(291133)
      %CsvReader.Model.OraclePaysheet{
          id: 291133.0,
          status: "ACTIVE"
      }
  """
  def get_paysheet!(id) do
    OraclePaysheet
    |> OracleRepo.get(id)
  end

  def get_batch_block!(id) do
    OracleBatchBlock
    |> OracleRepo.get(id)
  end

  def validate_result(nil, id) do
    p = Payroll.get_paysheet!(id)
    query_batch = validate_batch(p)
    """
    #{query_batch}
    Insert into nomina.prn_paysheet_detail(
      ID, YEAR, PAYMENT_TERM, DIVISION, CAMPUS, PROGRAM, MODALITY, TERM_CODE, FULLNAME_TEACHER, ENROLLMENT_EMPLOYEE,
      ENROLLMENT_TEACHER, COMPANY_NAME, PAYMENT_TYPE, PAYMENT_CODE, CRN, COURSE_CODE, COURSE_NUMBER, COURSE_NAME,
      BEGIN_DATE, END_DATE, START_TIME, END_TIME, SESSION_MINUTES, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY,
      SUNDAY, DURATION_FACTOR, NUMBER_OF_SESSIONS, FEE, AMOUNT_OF_SESSIONS, ABSENCES, AMOUNT_OF_ABSENCES, DELAYMENTS,
      AMOUNT_OF_DELAYMENTS, SUBSTITUTIONS, AMOUNT_OF_SUBSTITUTIONS, NET_HOURS, AMOUNT_OF_NET_HOURS, SOURCE, CAMPUS_CODE,
      AUTHORIZED_DELAYMENT, AUTHORIZED_DELAYMENT_DATE, AUTHORIZED_SUBSTITUTION, AUTHORIZED_SUBSTITUTION_DATE, AUTHORIZED_ABSENCE,
      AUTHORIZED_ABSENCE_DATE, BATCH_BLOCK_ID, DATE_CREATED, LAST_UPDATED, COMPANY_CODE, DIVISION_CODE, MODALITY_CODE,
      PAYMENT_TYPE_CODE, HOURS_CLASS, PROGRAM_NAME, LEVL, SCHD_CODE, OVER_RIDE, STUDENTS_NUMBER, STATUS
        ) values (
      #{id}, #{san(p.year)}, #{san(p.payment_term)}, #{san(p.division)}, #{san(p.campus)}, #{san(p.program)}, #{san(p.modality)},
      #{san(p.term_code)}, #{san(p.fullname_teacher)}, #{san(p.enrollment_employee)}, #{san(p.enrollment_teacher)}, #{san(p.company_name)},
      #{san(p.payment_type)}, #{san(p.payment_code)}, #{san(p.crn)}, #{san(p.course_code)}, #{san(p.course_number)}, #{san(p.course_name)},
      to_date(#{san(p.begin_date)}, 'YYYY-MM-DD'), to_date(#{san(p.end_date)}, 'YYYY-MM-DD'), #{san(p.start_time)}, #{san(p.end_time)}, #{san(p.session_minutes)}, #{san(p.monday)},
      #{san(p.tuesday)}, #{san(p.wednesday)}, #{san(p.thursday)}, #{san(p.friday)}, #{san(p.saturday)}, #{san(p.sunday)},
      #{san(p.duration_factor)}, #{san(p.number_of_sessions)}, #{san(p.fee)}, #{san(p.amount_of_sessions)}, #{san(p.absences)},
      #{san(p.amount_of_absences)}, #{san(p.delayments)}, #{san(p.amount_of_delayments)}, #{san(p.substitutions)}, #{san(p.amount_of_substitutions)},
      #{san(p.net_hours)}, #{san(p.amount_of_net_hours)}, #{san(p.source)}, #{san(p.campus_code)}, #{san(p.authorized_delayment)},
      to_date(#{san(p.authorized_delayment_date)}, 'YYYY-MM-DD'), #{san(p.authorized_substitution)}, to_date(#{san(p.authorized_substitution_date)}, 'YYYY-MM-DD'),
      #{san(p.authorized_absence)}, to_date(#{san(p.authorized_absence_date)}, 'YYYY-MM-DD'), #{san(p.batch_block_id)}, SYSDATE, SYSDATE, #{san(p.company_code)},
      #{san(p.division_code)}, #{san(p.modality_code)}, #{san(p.payment_type_code)}, #{san(p.hours_class)},#{san(p.program_name)}, #{san(p.levl)},
      #{san(p.schd_code)}, #{san(p.over_ride)}, #{san(p.students_number)}, #{san(p.status)}
      );
    """
  end
  def validate_result(paysheet, id) do
    change_paysheet_status(paysheet.status, id)
  end

  def validate_batch(paysheet) do
    get_batch_block!(paysheet.batch_block_id)
    |> make_batch_query(paysheet.batch_block_id)
  end

  def make_batch_query(nil, batch_id) do
    batch = Payroll.get_batch_block(batch_id)
    """
      Insert into nomina.PRN_BATCH_BLOCK (ID, USERNAME, STATUS, CAMPUS_CODE, DIVISION_CODE, BATCH_ID, DATE_CREATED, LAST_UPDATED) values
      (#{batch.id},
      '#{batch.username}',
      '#{batch.status}',
      '#{batch.campus_code}',
      '#{batch.division_code}',
      #{batch.batch_id},
      SYSDATE,
      SYSDATE);
    """
  end
  def make_batch_query(_, _), do: ""

  def san(''), do: "null"
  def san(nil), do: "null"
  def san(word), do: "'#{word}'"

  defp change_paysheet_status("ACTIVE", _), do: ""
  defp change_paysheet_status("DELETED", id) do
    "UPDATE nomina.prn_paysheet_detail SET status = 'ACTIVE' WHERE ID = #{id}; \n"
  end
end
