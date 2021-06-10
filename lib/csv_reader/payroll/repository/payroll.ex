defmodule CsvReader.Repository.Payroll do

  import Ecto.Query, warn: false
  alias CsvReader.Repo

  alias CsvReader.Model.Paysheet
  alias CsvReader.Model.BatchBlock

  def list_all_paysheets() do
    Repo.all(Paysheet)
  end

  def get_paysheet!(id) do
    Paysheet
    |> Repo.get(id)
    |> Repo.preload(:batch_block)
  end

  def get_batch_block(id) do
    BatchBlock
    |> Repo.get(id)
  end

  def get_paysheet_by_params(
    %{year: year,
    payment_term: payment_term,
    division: division,
    campus: campus,
    term_code: term_code,
    enrollment_employee: enrollment_employee,
    crn: crn
    }) do
    Paysheet
    |> where([p], p.year == ^year)
    |> where([p], p.payment_term == ^payment_term)
    |> where([p], p.division == ^division)
    |> where([p], p.campus == ^campus)
    |> where([p], p.term_code == ^term_code)
    |> where([p], p.enrollment_employee == ^enrollment_employee)
    |> where([p], p.crn == ^crn)
    |> Repo.all()
  end
end
