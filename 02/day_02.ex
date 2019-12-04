defmodule Day02 do
  def part1 do
    run(input(), 12, 2)
  end

  def part2 do
    input = input()

    for n <- 0..99, v <- 0..99 do
      {n, v}
    end
    |> Enum.find(fn {n, v} ->
      run(input, n, v) == 19_690_720
    end)
  end

  def run(input, a, b) do
    %{input | 1 => a, 2 => b}
    |> run(0)
  end

  def run(input, index) do
    case Map.get(input, index) do
      99 ->
        Map.get(input, 0)

      op when op in 1..2 ->
        op
        |> execute(input, index)
        |> run(index + 4)
    end
  end

  def execute(op, input, index) do
    {p1, p2, p3} = {index + 1, index + 2, index + 3}

    r1 = input[input[p1]]
    r2 = input[input[p2]]
    wp = input[p3]

    %{input | wp => do_op(op, r1, r2)}
  end

  def do_op(1, a, b), do: a + b
  def do_op(2, a, b), do: a * b

  def input do
    "02/input.txt"
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Stream.with_index()
    |> Stream.map(fn {value, index} -> {index, String.to_integer(value)} end)
    |> Map.new()
  end
end

ExUnit.start()

defmodule Day02Test do
  use ExUnit.Case

  test "part1" do
    assert Day02.part1() == 4_930_687
  end

  test "part2" do
    assert Day02.part2() == {53, 35}
  end
end
