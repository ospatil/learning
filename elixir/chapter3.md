# Chapter 3

<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [3.1 Pattern matching](#31-pattern-matching)
	- [3.1.1 The match operator](#311-the-match-operator)
	- [3.1.2 Matching tuples](#312-matching-tuples)
	- [3.1.3 Matching constants](#313-matching-constants)
	- [3.1.4 Variables in patterns](#314-variables-in-patterns)
	- [3.1.5 Matching lists](#315-matching-lists)
	- [3.1.6 Matching maps](#316-matching-maps)
	- [3.1.7 Matching bitstrings and binaries](#317-matching-bitstrings-and-binaries)
		- [Matching binary strings](#matching-binary-strings)
	- [3.1.8 Compound matches](#318-compound-matches)
- [3.2 Matching with functions](#32-matching-with-functions)
	- [3.2.1 Multiclause functions](#321-multiclause-functions)
	- [3.2.2 Guards](#322-guards)
	- [3.2.3 Multiclause lambdas](#323-multiclause-lambdas)
- [3.3 Conditionals](#33-conditionals)
	- [3.3.1 Branching with multiclause functions](#331-branching-with-multiclause-functions)
	- [3.3.2 Classical branching constructs](#332-classical-branching-constructs)
		- [if and unless](#if-and-unless)
		- [cond](#cond)
		- [case](#case)

<!-- /TOC -->

## 3.1 Pattern matching

### 3.1.1 The match operator

  + `=` is a match operator in elixir and not an assignment operator.

  ```elixir
  iex(1)> person = {"Bob", 25}
  ```

  + The left side is called *pattern* and right side is an expression.
  + In the example above, a variable `person` is being matched to the expression `{"Bob", 25}`. **A variable always matches the right side and becomes bound to the value of the expression.**

### 3.1.2 Matching tuples

  + Basic pattern matching with tuples example -

  ```elixir
  iex(1)> {name, age} = {"Bob", 25}

  iex(2)> name
  "Bob"

  iex(3)> age
  25

  iex(4)> {date, time} = :calendar.local_time # Erlang function :calendar.local_time/0

  iex(5)> {year, month, day} = date # date is also a tuple

  iex(6)> {hour, minute, second} = time # so is time
  ```

  + What happens if right side doesn't match pattern?

  ```elixir
  iex(7)> {name, age} = "can't match"
  ** (MatchError) no match of right hand side value: "can't match"
  ```

  + Like everything in elixir, match expression also returns a value. The result is always the right-side term you match against.

  ```elixir
  iex(8)> {name, age} = {"Bob", 25}
  {"Bob", 25}
  ```

### 3.1.3 Matching constants

  + the left-side pattern can also include constants.

  ```elixir
  iex(1)> 1 = 1 # it just proves that = is not an assignment operator.
  1

  iex(2)> person = {:person, "Bob", 25} # first element is constant atom :person

  iex(3)> {:person, name, age} = person # pattern is first element constant with value :person
  {:person, "Bob", 25}

  iex(4)> name
  "Bob"

  iex(5)> age
  25
  ```

  This is a common idiom in elixir. Many functions from Elixir and Erlang return either
  `{:ok, result}` or `{:error, reason}`.

  ```elixir
  {:ok, contents} = File.read("my_app.config")
  ```

  In this single line of code, three distinct things happen:

    1. An attempt to open and read the file my_app.config takes place.
    2. If the attempt succeeds, the file contents are extracted to the variable contents.
    3. If the attempt fails, an error is raised. This happens because the result of
    `File.read` is a tuple in the form `{:error, reason}`, and therefore the match to
    `{:ok, contents}` fails.

### 3.1.4 Variables in patterns

  + Variable names in patterns always match and are bound to the value of the expression.
  + If you are not interested in a value from right-side expression, use `_`.

  ```elixir
  iex(1)> {_, time} = :calendar.local_time

  iex(2)> time
  {20, 44, 18}
  ```

  + Patterns can be arbitrarily nested.

  ```elixir
  iex(3)> {_, {hour, _, _}} = :calendar.local_time

  iex(4)> hour
  20
  ```

  + A variable can be referenced multiple times in the same pattern.

  ```elixir
  iex(5)> {amount, amount, amount} = {127, 127, 127} # Matches a tuple with three identical elements
  {127, 127, 127}

  iex(6)> {amount, amount, amount} = {127, 127, 1} # Fails because the tuple elements aren’t identical
  ** (MatchError) no match of right hand side value: {127, 127, 1}
  ```

  + *Pin operator* `^` can be used to match against contents of a variable. NOTE that the pin operator doesn't bind the variable. This is used rarely and is relevant when a pattern needs to be constructed at runtime.

  ```elixir
  iex(7)> expected_name = "Bob" # Matches anything and then binds to the variable expected_name
  "Bob"

  iex(8)> {^expected_name, _} = {"Bob", 25} # Matches to the content of the variable
  {"Bob", 25}

  iex(9)> {^expected_name, _} = {"Alice", 30} # Matches to the content of the variable expected_name
  ** (MatchError) no match of right hand side value: {"Alice", 30}
  ```

### 3.1.5 Matching lists
  + Works similar to tuples.

  ```elixir
  iex(1)> [first, second, third] = [1, 2, 3]
  [1, 2, 3]

  [1, second, third] = [1, 2, 3] # first element must be 1
  [first, first, first] = [1, 1, 1] # all elements must have same value
  [first, second, _ ] = [1, 2, 3] # don't care about 3rd element but it must be present
  [^first, second, _ ] = [1, 2, 3] # first element must have the same value as the variable first
  ```

  + Lists are often matched by relying on their recursive nature.

  ```elixir
  iex(3)> [head | tail] = [1, 2, 3]
  [1, 2, 3]

  iex(4)> head
  1

  iex(5)> tail
  [2, 3]

  iex(6)> [min | _] = Enum.sort([3,2,1]) # an inefficient way of getting smallest element in the list
  iex(7)> min
  1
  ```

### 3.1.6 Matching maps

```elixir
iex(1)> %{name: name, age: age} = %{name: "Bob", age: 25}
%{age: 25, name: "Bob"}

iex(2)> name
"Bob"

iex(3)> age
25

iex(4)> %{age: age} = %{name: "Bob", age: 25} # left-side pattern need not contain all keys
iex(5)> age
25

iex(6)> %{age: age, works_at: works_at} = %{name: "Bob", age: 25} # fail because pattern contains key not there in map
** (MatchError) no match of right hand side value
```

### 3.1.7 Matching bitstrings and binaries

```elixir
iex(1)> binary = <<1, 2, 3>>
<<1, 2, 3>>

iex(2)> <<b1, b2, b3>> = binary # a binary match for a 3-byte binary
<<1, 2, 3>>
iex(3)> b1
1
iex(4)> b2
2
iex(5)> b3
3

iex(6)> <<b1, rest :: binary>> = binary # take apart binary by taking first byte in one variable and rest into other.
<<1, 2, 3>>
iex(7)> b1
1
iex(8)> rest
<<2, 3>>

iex(9)> <<a :: 4, b :: 4>> = <<155>> # pattern a::4 states a four-bit value is expected. 155 = 1001 (9) 1011 (11)
<<155>>
iex(10)> a
9
iex(11)> b
11
```

#### Matching binary strings

```elixir
iex(13)> <<b1, b2, b3>> = "ABC"
"ABC"
iex(13)> b1
65
iex(14)> b2
66
iex(15)> b3
67

iex(16)> command = "ping www.example.com"
"ping www.example.com"
iex(17)> "ping " <> url = command # the expectation is command variable is a binary string starting with "ping "
"ping www.example.com"
iex(18)> url # since the expectation matches, rest of the string is bound to the variable url
"www.example.com"
```

### 3.1.8 Compound matches
  + Patterns can be arbitrarily nested.

  ```elixir
  iex(1)> [_, {name, _}, _] = [{"Bob", 25}, {"Alice", 30}, {"John", 35}]
  ```

  + Match expressions can be chained.

  ```elixir
  iex(3)> a = (b = 1 + 3) # parens are optional so it could be written as a = b = 1 + 3
  4
  ```

  In the above example, following things happen:

    1. The expression 1 + 3 is evaluated.
    2. The result (4) is matched against the pattern b.
    3. The result of the inner match (which is again 4) is matched against the pattern a.

  Some more useful examples of this are:

  ```elixir
  iex(5)> :calendar.local_time
  {{2013, 11, 11}, {21, 28, 41}}

  iex(6)> date_time = {_, {hour, _, _}} = :calendar.local_time # retrieve datetime as well as hour

  iex(7)> {_, {hour, _, _}} = date_time = :calendar.local_time # the ordering can be swapped.

  iex(8)> date_time
  {{2013, 11, 11}, {21, 32, 34}}

  iex(9)> hour
  21
  ```

## 3.2 Matching with functions

  + To recall, a basic function definition is

  ```elixir
  def my_fun(arg1, arg2) do
    ...
  end
  ```

  The parameters are patterns and they are matched to the arguments user passes in.

### 3.2.1 Multiclause functions

  + Elxir allows us to *"overload"* a function by specifying multiple *clauses* for a function with same arity. NOTE that from callers perspective, a multiclause function is a single function. You can't directly reference a specific clause.

  Consider an example - creating a `Geometry` module. The shapes it handles are tuples with first element of each denoting the type.

  ```elixir
  rectangle = {:rectangle, 4, 5}
  square = {:square, 5}
  circle = {:circle, 4}

  defmodule Geometry do
    def area({:rectangle, a, b}) do # first clause of area/1
      a * b
    end

    def area({:square, a}) do # second clause of area/1
      a * a
    end

    def area({:circle, r}) do # third clause of area/1
      r * r * 3.14
    end
  end

  iex(1)> Geometry.area({:rectangle, 4, 5})
  20
  iex(2)> Geometry.area({:square, 5})
  25
  iex(3)> Geometry.area({:circle, 4})
  50.24

  iex(4)> Geometry.area({:triangle, 1, 2, 3}) # error if match fails. area function doesn't have a match for triangle
  ** (FunctionClauseError) no function clause matching in Geometry.area/1
  geometry.ex:2: Geometry.area({:triangle, 1, 2, 3})
  ```

  + We can add a default clause that always matches. Useful to return a term indicating failure instead of raising an error as above.

  ```elixir
  defmodule Geometry do
    def area({:rectangle, a, b}) do
      a * b
    end

    def area({:square, a}) do
      a * a
    end

    def area({:circle, r}) do
      r * r * 3.14
    end

    def area(unknown) do # unknown is a variable therefore the match always succeeds with any argument
      {:error, {unknown_shape, unknown}}
    end
  end

  iex(1)> Geometry.area({:square, 5})
  25
  iex(2)> Geometry.area({:triangle, 1, 2, 3})
  {:error, {:unknown_shape, {:triangle, 1, 2, 3}}}
  ```

  + Always group together clauses of same function.
  + The sequence of the clauses matters. The matching takes place from top to down. If we move the "unknown" clause as first clause, it will match to any argument that is passed in every time and no other clauses will match.

### 3.2.2 Guards

  + **Guards** allow to add additional expectations that must be satisfied by the caller of a function.

  ```elixir
  defmodule TestNum do
    def test(x) when x < 0 do
    :negative
    end

    def test(0), do: :zero

    def test(x) when x > 0 do
    :positive
    end
  end

  iex(1)> TestNum.test(-1)
  :negative
  iex(2)> TestNum.test(0)
  :zero
  iex(3)> TestNum.test(1)
  :positive
  ```

  + If we call above with non-number, we get strange result owing to Elixir's type ordering that the comparison operators use.

  ```elixir
  iex(4)> TestNum.test(:not_a_number)
  :positive
  ```

  The type ordering is as follows - `number < atom < reference < fun < port < pid < tuple < map < list < bitstring (binary)`

  To fix above, we can use Kernel.is_number/1 to add a number check.

  ```elixir
  defmodule TestNum do
    def test(x) when is_number(x) and x < 0 do
    :negative
    end

    def test(0), do: :zero

    def test(x) when is_number(x) and x > 0 do
    :positive
    end
  end

  iex(1)> TestNum.test(-1)
  :negative
  iex(2)> TestNum.test(:not_a_number) # no match therefore error
  ** (FunctionClauseError) no function clause matching in TestNum.test/1
  ```

  + Guards can make use of a limited subset of operators and functions.

    + Comparison operators (==, !=, ===, !==, >, <, <=, >=)
    + Boolean operators (and, or) and negation operators (not, !)
    + Arithmetic operators (+, -, *, /)
    + <> and ++ as long as the left side is a literal
    + in operator
    + Type-check functions from the Kernel module (for example, is_number/1, is_atom/1, and so on)
    + Additional Kernel function abs/1, bit_size/1, byte_size/1, div/2, elem/2, hd/1, length/1, map_size/1, node/0, node/1, rem/2, round/1, self/0, tl/1, trunc/1, and tuple_size/1

  + Error raised in the guard won't be propagated and the guard expression will return false.

  ```elixir
  defmodule ListHelper do
    def smallest(list) when length(list) > 0 do
      Enum.min(list)
    end

    def smallest(_), do: {:error, :invalid_argument}
  end

  iex(1)> ListHelper.smallest(123) # length/1 only makes sense on lists so the guard of first clause returns false and second clause is executed.
  {:error, :invalid_argument}
  ```

### 3.2.3 Multiclause lambdas

  + Lambdas may also contain multiple clauses.

  ```elixir
  iex(3)> test_num = fn
            x when is_number(x) and x < 0 ->
              :negative

            0 -> :zero

            x when is_number(x) and x > 0 ->
              :positive
            end

  iex(4)> test_num.(-1)
  :negative
  iex(5)> test_num.(0)
  :zero
  iex(6)> test_num.(1)
  :positive
  ```

## 3.3 Conditionals

### 3.3.1 Branching with multiclause functions

  + We have already seen this -

  ```elixir
  defmodule TestNum do # the three clauses constitute three conditional branches
    def test(x) when x < 0, do: :negative
    def test(0), do: :zero
    def test(x), do: :positive
  end
  ```

  The above can be represented in a typical imperative language (javascript) as

  ```javascript
  function test(x){
    if (x < 0) return "negative";
    if (x == 0) return "zero";
    return "positive";
  }
  ```

  + Another example - to check if given list is empty

  ```elixir
  defmodule TestList do
    def empty?([]), do: true
    def empty?([_|_]), do: false
  end
  ```

  + Pattern matching can allow implementing polymorphic functions.

  ```elixir
  iex(1)> defmodule Polymorphic do # double the input
            def double(x) when is_number(x), do: 2 * x # for number multiply by two
            def double(x) when is_binary(x), do: x <> x # for string concat it to itself
          end

  iex(2)> Polymorphic.double(3)
  6
  iex(3)> Polymorphic.double("Jar")
  "JarJar"
  ```

  + recursion is made easy by multiclauses.

  ```elixir
  iex(4)> defmodule Fact do
    def fact(0), do: 1
    def fact(n), do: n * fact(n - 1)
  end

  iex(5)> Fact.fact(1)
  1
  iex(6)> Fact.fact(3)
  6
  ```

  + Multiclause-powered recursion is also the primary building block for looping.

  ```elixir
  iex(7)> defmodule ListHelper do
            def sum([]), do: 0
            def sum([head | tail]), do: head + sum(tail)
          end
  iex(8)> ListHelper.sum([])
  0
  iex(9)> ListHelper.sum([1, 2, 3])
  6
  ```

  + Multiclauses and pattern-matching really shine when you have to combine functions that deal with different kind of results.

  ```javascript
  var result = callSomeOperation(...);
  if (result) {
    doSomething(result);
  } else {
    reportError();
  }
  ```

  ```elixir
  defmodule LinesCounter do
    def count(path) do
      File.read(path) # the main code
      |> lines_num
    end

    defp lines_num({:ok, contents}) do # success branch
      contents # start with content
      |> String.split("\n") # split it into list of lines
      |> length # return length of list
    end

    defp lines_num(error), do: error # error branch, return the error
  end
  ```

### 3.3.2 Classical branching constructs

  + Multiclauses require creating a separate function and passing necessary arguments. Sometimes it's simpler to use a classical branching construct. The macros `if`, `unless`, `cond` and `case` provide such functionality.

#### if and unless

  + Syntax

  ```elixir
  if condition do
    ...
  else
    ...
  end

  if condition, do: something, else: another_thing # a one-liner syntax
  ```

  ```elixir
  iex(1)> if 5 > 3, do: :one
  :one
  iex(2)> if 5 < 3, do: :one
  nil
  iex(3)> if 5 < 3, do: :one, else: :two
  :two

  def max(a, b) do
    if a >= b, do: a, else: b
  end

  def max(a, b) do
    unless a >= b, do: b, else a
  end
  ```

#### cond

  + syntax

  ```elixir
  cond do
    expression_1 ->
    ...
    expression_2 ->
    ...
  end
  ```

  The result of `cond` is the result of the corresponding executed block.

  ```elixir
  def max(a, b) do
    cond do
      a >= b -> a
      true -> b # equivalent of default clause. cond will throw an error if default is not present
    end
  end
  ```

#### case

  + syntax

  ```elixir
  case expression do
    pattern1 ->
    pattern2 ->
    ...
    _ -> ... # default clause that always matches
  end
  ```

  In case of `case`, the provided expression is evaluated and then the result is pattern-matched against given clauses.

  ```elixir
  def max(a, b) do
    case a >= b do
      true -> a
      false -> b
    end
  end
  ```
