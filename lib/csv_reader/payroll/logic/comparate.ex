defmodule CsvReader.Logic.Comparate do

  alias CsvReader.Logic.Reader

  @doc """
    Comparate nrcs files

    ## Example

    iex> Comparate.comparate_files("./files/2020Enero.xlsx" ,"./new_files/2020Enero.xlsx")

    %{
      old_enrollments: [],
      new_enrollments: [],
      old_sum: 15_000,
      new_sum: 15_000
    }
  """
  def comparate_files(path, new_path) do
    enrollments = nrcs_of_file(path)
    new_enrollments = nrcs_of_file(new_path)
    net_sum = net_hours_of_file(path)
    net_new_sum = net_hours_of_file(new_path)

    %{old_enrollments: enrollments -- new_enrollments,
      new_enrollments: new_enrollments -- enrollments,
      old_sum: net_sum,
      new_sum: net_new_sum}
  end

  defp nrcs_of_file(path) do
    path
    |> Reader.read()
    |> Enum.map(&get_nrcs/1)
  end

  defp net_hours_of_file(path) do
    path
    |> Reader.read()
    |> Enum.map(&get_net_hours/1)
    |> Enum.filter(fn n -> !is_binary(n) end)
    |> Enum.sum()
  end

  defp get_nrcs(list) do
    [_, _, _, _, _, _, _, _, _, _, _, _, crn, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _] = list
    crn
  end

  defp get_net_hours(list) do
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _,
    _, _, _, _, _, _, _, net_hours, _] = list
    net_hours
  end

end
