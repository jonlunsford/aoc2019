defmodule MassReduce do
  def call(file) do
    File.stream!(file)
    |> Stream.map(fn line ->
      {integer, _other} = Integer.parse(line)
      calc_fuel(integer)
    end)
    |> Enum.sum()
  end

  def calc_fuel(num, list \\ [])

  def calc_fuel(num, list) when num <= 0, do: Enum.sum(list)

  def calc_fuel(num, list) do
    int =
      case Integer.floor_div(num, 3) - 2 do
        n when n > 0 -> n
        _ -> 0
      end

    list = [int | list]
    calc_fuel(int, list)
  end
end

ExUnit.start()

defmodule MassReduceTest do
  use ExUnit.Case

  setup do
    file_name = "01/input-test.txt"
    File.write(file_name, "12\n14\n1969\n100756\n")
    {:ok, %{file_name: file_name}}
  end

  describe ".calc_fuel" do
    test "it calculates required fuel" do
      assert MassReduce.calc_fuel(100_756) == 50346
    end
  end

   describe ".call" do
     test "calculates required mass", %{file_name: file_name} do
       assert MassReduce.call(file_name) == 51316
     end
   end
end
