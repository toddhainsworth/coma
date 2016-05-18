defmodule ComaTest do
  use ExUnit.Case
  doctest Coma

  test "read/1 when file does not exist" do
    assert Coma.read("does_not_exist") == { :error, "File not found" }
  end

  test "read/1 when file does exist and does not contain any text" do
    assert Coma.read("empty_csv.csv") == { :ok, [] }
  end

  test "read/1 when file does exist and contains a single comma separated line" do
    assert Coma.read("single_line.csv") == { :ok, [["test", "this", "out"]] }
  end

  test "read/1 when file does exist and contains many comma separated lines" do
    assert Coma.read("multi_line.csv") == { :ok, [
      ["test", "this", "out"],
      ["foo", "the", "bar"]
    ] }
  end

  test "read/1 when file does exist but is not a valid csv file" do
    assert Coma.read("not_valid.csv") == { :ok, [["the contents"]] }
  end
end
