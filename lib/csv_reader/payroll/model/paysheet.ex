defmodule CsvReader.Model.Paysheet do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]

  alias CsvReader.Model.BatchBlock

  @states ["ACTIVE", "DELETED", "REPROCESS"]

  schema "paysheet" do
    field :year, :string
    field :payment_term, :string
    field :division, :string
    field :campus, :string
    field :program, :string
    field :modality, :string
    field :term_code, :string
    field :fullname_teacher, :string
    field :enrollment_employee, :string
    field :enrollment_teacher, :string
    field :company_name, :string
    field :payment_type, :string
    field :payment_code, :string
    field :crn, :string
    field :course_code, :string
    field :course_number, :integer
    field :course_name, :string
    field :begin_date, :date
    field :end_date, :date
    field :start_time, :time
    field :end_time, :time
    field :session_minutes, :integer
    field :monday, :string
    field :tuesday, :string
    field :wednesday, :string
    field :thursday, :string
    field :friday, :string
    field :saturday, :string
    field :sunday, :string
    field :duration_factor, :integer
    field :number_of_sessions, :integer
    field :fee, :float
    field :amount_of_sessions, :float
    field :absences, :float
    field :amount_of_absences, :float
    field :delayments, :float
    field :amount_of_delayments, :float
    field :substitutions, :float
    field :amount_of_substitutions, :float
    field :net_hours, :float
    field :amount_of_net_hours, :float
    field :source, :string
    field :campus_code, :string
    field :authorized_delayment, :string
    field :authorized_delayment_date, :date
    field :authorized_substitution, :string
    field :authorized_substitution_date, :date
    field :authorized_absence, :string
    field :authorized_absence_date, :date
    field :company_code, :string
    field :division_code, :string
    field :modality_code, :string
    field :payment_type_code, :string
    field :hours_class, :float
    field :program_name, :string
    field :levl, :string
    field :schd_code, :string
    field :observation, :string, default: "SIN OBSERVACIÓN", virtual: true
    field :over_ride, :string
    field :students_number, :integer, default: 0
    field :status, :string, default: "ACTIVE"
    timestamps()
    belongs_to :batch_block, BatchBlock
  end

  def changeset(paysheet, attrs) do
    paysheet
    |> cast(attrs, [:year, :payment_term, :division, :campus, :program, :modality, :term_code, :fullname_teacher, :enrollment_employee, :enrollment_teacher, :company_name, :payment_type, :payment_code, :crn, :course_code, :course_number, :course_name, :begin_date, :end_date, :start_time, :end_time, :session_minutes, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :duration_factor, :number_of_sessions, :fee, :amount_of_sessions, :absences, :amount_of_absences, :delayments, :amount_of_delayments, :substitutions, :amount_of_substitutions, :net_hours, :amount_of_net_hours, :source, :campus_code, :authorized_delayment, :authorized_delayment_date, :authorized_substitution, :authorized_substitution_date, :authorized_absence, :authorized_absence_date,:company_code, :division_code, :modality_code, :payment_type_code, :hours_class, :program_name, :levl, :schd_code, :students_number, :over_ride, :status])
    |> validate_inclusion(:status, @states)
  end
end
