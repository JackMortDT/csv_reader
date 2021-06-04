defmodule CsvReader.Logic.ReaderTest do
  use ExUnit.Case, async: true

  alias CsvReader.Logic.Reader

  describe "file" do

    @query_list [
      "UPDATE paysheet SET status = 'ACTIVE' WHERE ID = 1; \n",
      "UPDATE paysheet SET status = 'ACTIVE' WHERE ID = 2; \n",
      "UPDATE paysheet SET status = 'ACTIVE' WHERE ID = 3; \n",
      "UPDATE paysheet SET status = 'ACTIVE' WHERE ID = 4; \n",
      "UPDATE paysheet SET status = 'ACTIVE' WHERE ID = 5; \n",
    ]
    @file_name "test.xlsx"

    @tag query_list: "list"
    test "add_query_to_file/2" do
      Reader.add_query_to_file(@query_list, @file_name)
      assert File.exists?("./sql/#{@file_name}.sql")
      File.rm!("./sql/#{@file_name}.sql")
    end
  end

  describe "paysheets" do

    alias CsvReader.Model.Paysheet

    @paysheet_a %Paysheet{id: 1, updated_at: ~U[2021-06-05 22:43:00.730109Z]}
    @paysheet_b %Paysheet{id: 2, updated_at: ~U[2021-06-04 22:43:00.730109Z]}
    @paysheet_c %Paysheet{id: 3, updated_at: ~U[2021-06-04 22:42:00.730109Z]}

    @paysheets [@paysheet_a, @paysheet_b, @paysheet_c]

    @tag paysheets: "paysheets"
    test "get_max/1" do
      paysheet = Reader.get_max(@paysheets)
      assert paysheet == @paysheet_a
    end

    @tag paysheets: "paysheets"
    test "max_paysheet/2" do
      paysheet = Reader.max_paysheet(@paysheet_a, @paysheet_b)
      assert paysheet == @paysheet_a
    end
  end
end
