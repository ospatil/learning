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
