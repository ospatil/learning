defmodule MyList do
  def mapsum(list, func), do: _mapsum(list, func, 0)
  def _mapsum([], _func, acc), do: acc
  def _mapsum([head | tail], func, acc), do: _mapsum(tail, func, acc + func.(head))

  def max([a]), do: a
  def max([ head | tail ]), do: Kernel.max(head, max(tail))

  def min([a]), do: a
  def min([ head | tail ]), do: Kernel.min(head, min(tail))
end
