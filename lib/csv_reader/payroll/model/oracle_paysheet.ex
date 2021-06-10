defmodule CsvReader.Model.OraclePaysheet do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  @states ["ACTIVE", "DELETED", "REPROCESS"]

  @primary_key {:id, :float, []}
  schema "prn_paysheet_detail" do
    field :status, :string, default: "ACTIVE"
  end

  def changeset(paysheet, attrs) do
    paysheet
    |> cast(attrs, [:year, :payment_term, :division, :campus, :program, :modality, :term_code, :fullname_teacher, :enrollment_employee, :enrollment_teacher, :company_name, :payment_type, :payment_code, :crn, :course_code, :course_number, :course_name, :begin_date, :end_date, :start_time, :end_time, :session_minutes, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :duration_factor, :number_of_sessions, :fee, :amount_of_sessions, :absences, :amount_of_absences, :delayments, :amount_of_delayments, :substitutions, :amount_of_substitutions, :net_hours, :amount_of_net_hours, :source, :campus_code, :authorized_delayment, :authorized_delayment_date, :authorized_substitution, :authorized_substitution_date, :authorized_absence, :authorized_absence_date,:company_code, :division_code, :modality_code, :payment_type_code, :hours_class, :program_name, :levl, :schd_code, :students_number, :over_ride, :status])
    |> validate_inclusion(:status, @states)
  end
end
