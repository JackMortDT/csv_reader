defmodule CsvReader.Logic.ReaderTest do
  use ExUnit.Case

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
end