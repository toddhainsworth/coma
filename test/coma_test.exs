defmodule ComaTest do
  use ExUnit.Case

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

  test "write_row/3 when all arguments are valid" do
    assert Coma.write_row(["test", "this", "out"], "my_csv.csv", :overwrite)
      == { :ok, ["test", "this", "out"] }

    assert File.read("my_csv.csv") == { :ok, "test,this,out\n" }
  end

  test "write_row/3 when the file does not exist" do
    assert File.exists?("does_not_exist") == false
    assert Coma.write_row(["test", "this", "out"], "does_not_exist", :overwrite)
      == { :ok, ["test", "this", "out"] }
    assert File.exists?("does_not_exist") == true
    # Cleanup
    File.rm("does_not_exist")
  end

  test "write_row/3 when mode is :append" do
    Coma.write_row(["test", "this", "out"], "append_to_this.csv", :append)
    Coma.write_row(["foo", "the", "bar"], "append_to_this.csv", :append)

    { _, contents } = File.read("append_to_this.csv")
    assert contents == "test,this,out\nfoo,the,bar\n"

    # Cleanup
    File.rm("append_to_this.csv")
  end

  test "write_row/3 when mode is :overwrite" do
    Coma.write_row(["test", "this", "out"], "overwrite_this.csv", :overwrite)
    Coma.write_row(["foo", "the", "bar"], "overwrite_this.csv", :overwrite)

    { _, contents } = File.read("overwrite_this.csv")
    assert contents == "foo,the,bar\n"

    # Cleanup
    File.rm("overwrite_this.csv")
  end

  test "write_row/3 when mode is not included" do
    Coma.write_row(["test", "this", "out"], "append_to_this.csv")
    Coma.write_row(["foo", "the", "bar"], "append_to_this.csv")

    { _, contents } = File.read("append_to_this.csv")
    assert contents == "test,this,out\nfoo,the,bar\n"

    # Cleanup
    File.rm("append_to_this.csv")
  end

  test "write_row/3 when mode is not a supported type" do
    Coma.write_row(["test", "this", "out"], "append_to_this.csv", :foo)
    Coma.write_row(["foo", "the", "bar"], "append_to_this.csv", :foo)

    { _, contents } = File.read("append_to_this.csv")
    assert contents == "foo,the,bar\n"

    # Cleanup
    File.rm("append_to_this.csv")
  end
end
