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
end
