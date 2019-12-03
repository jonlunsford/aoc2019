defmodule MassSum do
  def call(file) do
    File.stream!(file)
    |> Stream.map(fn(line) ->
      {integer, _other} = Integer.parse(line)
      Integer.floor_div(integer, 3) - 2
    end)
    |> Enum.sum
  end
end

ExUnit.start()

defmodule MassSumTest do
  use ExUnit.Case

  setup do
    file_name = "input-test.txt"
    File.write(file_name, "12\n14\n1969\n100756\n")
    {:ok, %{file_name: file_name}}
  end

  describe ".call" do
    test "calculates required mass", %{file_name: file_name} do
      assert MassSum.call(file_name) == 34241
    end
  end
end
