# Print Natural numbers upto n
defmodule NaturalNums do
  def print(1), do: IO.puts(1)

  def print(n) do
    print(n - 1)
    IO.puts(n)
  end
end

# Calculating sum of a list - non tail-recursive
defmodule ListHelper do
  def sum([]), do: 0

  def sum([head | tail]) do
    head + sum(tail)
  end

  # Tail recursive version
  def sum_tr(list) do
    do_sum(0, list)
  end

  defp do_sum(current_sum, []) do
    current_sum
  end

  defp do_sum(current_sum, [head | tail]) do
    current_sum + head
    |> do_sum(tail)
  end
end
