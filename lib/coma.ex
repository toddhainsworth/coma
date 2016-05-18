defmodule Coma do
  def read(filename) do
    if File.exists?(filename) do
      case File.read(filename) do
        { :ok, contents } -> { :ok, parse_csv contents }
        error -> error
      end
    else
      { :error, "File not found" }
    end
  end

  defp parse_csv(contents) do
    String.split(contents, "\n")              # Split into rows
    |> Enum.reject(&(String.length(&1) == 0)) # Remove blank rows
    |> Enum.map(&(String.split(&1, ",")))     # Split rows into columns
  end
end
