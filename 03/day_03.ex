defmodule Day03 do
  def part1(file_name) do
    [set_1, set_2] =
      file_name
      |> File.read!()
      |> String.split()
      |> Enum.map(&path_to_map/1)
      |> Enum.map(&connect/1)
      |> Enum.map(&MapSet.new/1)

    MapSet.intersection(set_1, set_2)
    |> MapSet.delete({0, 0})
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min()
  end

  def part2(file_name) do
    [set_1, set_2] =
      file_name
      |> File.read!()
      |> String.split()
      |> Enum.map(&path_to_map/1)
      |> Enum.map(&connect/1)

    path1 = MapSet.new(set_1)
    path2 = MapSet.new(set_2)

    MapSet.intersection(path1, path2)
    |> MapSet.delete({0, 0})
    |> Enum.map(fn point ->
      index1 = Enum.find_index(set_1, fn pos -> pos == point end)
      index2 = Enum.find_index(set_2, fn pos -> pos == point end)
      index1 + index2
    end)
    |> Enum.min()
  end

  def path_to_map(path) when is_bitstring(path) do
    path
    |> String.split(",")
    |> Enum.map(fn
      "U" <> num -> {:up, String.to_integer(num)}
      "D" <> num -> {:down, String.to_integer(num)}
      "L" <> num -> {:left, String.to_integer(num)}
      "R" <> num -> {:right, String.to_integer(num)}
    end)
  end

  def connect(map, acc \\ [{0, 0}])
  def connect([], acc), do: Enum.reverse(acc)
  def connect([{_, 0} | rest], acc), do: connect(rest, acc)

  def connect([{dir, num} | rest], [{x, y} | _] = acc) do
    num = num - 1

    point =
      case dir do
        :up -> {x, y + 1}
        :down -> {x, y - 1}
        :left -> {x - 1, y}
        :right -> {x + 1, y}
      end

    connect([{dir, num} | rest], [point | acc])
  end
end

ExUnit.start()

defmodule Day03Test do
  use ExUnit.Case

  setup do
    file_name = "03/input-test.txt"
    File.write(file_name, "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
    {:ok, %{file_name: file_name}}
  end

  test "part1", %{file_name: file_name} do
    assert Day03.part1(file_name) == 159
  end

  test "part2", %{file_name: file_name} do
    assert Day03.part2(file_name) == 610
  end

  test "path_to_map" do
    assert Day03.path_to_map("R75,D30,R83,U83,L12,D49,R71,U7,L72") == [
             right: 75,
             down: 30,
             right: 83,
             up: 83,
             left: 12,
             down: 49,
             right: 71,
             up: 7,
             left: 72
           ]
  end

  test "connect" do
    map = Day03.path_to_map("R2,D3,R3,U8")

    assert Day03.connect(map) == [
             {0, 0},
             {1, 0},
             {2, 0},
             {2, -1},
             {2, -2},
             {2, -3},
             {3, -3},
             {4, -3},
             {5, -3},
             {5, -2},
             {5, -1},
             {5, 0},
             {5, 1},
             {5, 2},
             {5, 3},
             {5, 4},
             {5, 5}
           ]
  end
end
