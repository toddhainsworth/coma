defmodule ComaTest do
  use ExUnit.Case

  test "read/1 when file does exist and does not contain any text" do
    assert Coma.read("test/fixtures/empty_csv.csv") == { :ok, [] }
  end

  test "read/1 when file does exist and contains a single comma separated line" do
    assert Coma.read("test/fixtures/single_line.csv") == { :ok, [["test", "this", "out"]] }
  end

  test "read/1 when file does exist and contains many comma separated lines" do
    assert Coma.read("test/fixtures/multi_line.csv") == { :ok, [
      ["test", "this", "out"],
      ["foo", "the", "bar"]
    ] }
  end

  test "read/1 when file does exist but is not a valid csv file" do
    assert Coma.read("test/fixtures/not_valid.csv") == { :ok, [["the contents"]] }
  end

  test "write/3 when all arguments are valid" do
    assert Coma.write(["test", "this", "out"], "test/fixtures/my_csv.csv", :overwrite)
      == { :ok, ["test", "this", "out"] }

    assert File.read("test/fixtures/my_csv.csv") == { :ok, "test,this,out\n" }
  end

  test "write/3 when the file does not exist" do
    assert File.exists?("test/fixtures/does_not_exist") == false
    assert Coma.write(["test", "this", "out"], "test/fixtures/does_not_exist", :overwrite)
      == { :ok, ["test", "this", "out"] }
    assert File.exists?("test/fixtures/does_not_exist") == true
    # Cleanup
    File.rm("test/fixtures/does_not_exist")
  end

  test "write/3 when mode is :append" do
    Coma.write(["test", "this", "out"], "test/fixtures/append_to_this.csv", :append)
    Coma.write(["foo", "the", "bar"], "test/fixtures/append_to_this.csv", :append)

    { _, contents } = File.read("test/fixtures/append_to_this.csv")
    assert contents == "test,this,out\nfoo,the,bar\n"

    # Cleanup
    File.rm("test/fixtures/append_to_this.csv")
  end

  test "write/3 when mode is :overwrite" do
    Coma.write(["test", "this", "out"], "test/fixtures/overwrite_this.csv", :overwrite)
    Coma.write(["foo", "the", "bar"], "test/fixtures/overwrite_this.csv", :overwrite)

    { _, contents } = File.read("test/fixtures/overwrite_this.csv")
    assert contents == "foo,the,bar\n"

    # Cleanup
    File.rm("test/fixtures/overwrite_this.csv")
  end

  test "write/3 when mode is not included" do
    Coma.write(["test", "this", "out"], "test/fixtures/append_to_this.csv")
    Coma.write(["foo", "the", "bar"], "test/fixtures/append_to_this.csv")

    { _, contents } = File.read("test/fixtures/append_to_this.csv")
    assert contents == "test,this,out\nfoo,the,bar\n"

    # Cleanup
    File.rm("test/fixtures/append_to_this.csv")
  end

  test "write/3 when mode is not a supported type" do
    Coma.write(["test", "this", "out"], "test/fixtures/append_to_this.csv", :foo)
    Coma.write(["foo", "the", "bar"], "test/fixtures/append_to_this.csv", :foo)

    { _, contents } = File.read("test/fixtures/append_to_this.csv")
    assert contents == "foo,the,bar\n"

    # Cleanup
    File.rm("test/fixtures/append_to_this.csv")
  end
end
