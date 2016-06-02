defmodule Coma do
  @moduledoc """
  This is the core module of Coma.
  """

  @doc """
  Reads and parses the file identified by the given filename
  """
  def read(filename) do
    case File.read(filename) do
      { :ok, contents } -> { :ok, parse_csv contents }
      error -> error
    end
  end

  @doc """
  Writes the row to the file identified by the given filename based
  on the given mode (defaults to :append).

  ## Modes

  The available modes include:
  - :append (Default, append to the end of the file)
  - :overwrite (Overwrite the contents of the file with the given row)
  """
  def write(row, filename, mode \\ :append) do
    csv = Enum.join(row, ",") <> "\n"
    write_mode = case mode do
      :append -> :append
      :overwrite -> :write
      _ -> :write
    end

    # TODO: Better to use File.open/2 as per the docs for File.write/3
    # Because if this is ever used within a loop (likely) we will get decreased
    # performance
    case File.write(filename, csv, [write_mode]) do
      :ok   -> { :ok , row }
      error -> error
    end
  end


  defp parse_csv(contents) do
    String.split(contents, "\n")              # Split into rows
    |> Enum.reject(&(String.length(&1) == 0)) # Remove blank rows
    |> Enum.map(&(String.split(&1, ",")))     # Split rows into columns
  end
end
