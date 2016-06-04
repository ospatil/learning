# Elixir in action notes

## Chapter 2

### 2.1 REPL

+ Running - `iex`
+ Exiting - `Ctrl + c` or clean closing - `System.halt`
+ Help - `h`, ex. `h IEx`
+ clear the console - `clear`

### 2.2 Variables

+ Naming convention - snake case (ex - variable_name). Variable names allowed to end with ? and !.
+ `=` is a bind operator and not assignment operator. Rebinding a variable to different value is allowed.

### 2.3 Organizing Code

#### 2.3.1 Modules

+ Outputting to console - `IO.puts`
+ Accepting input from console - `IO.gets "Votre nom? "`
+ Defining a module -

  ```elixir
  defmodule Geometry do
    def rectangle_area(a, b) do
      a * b
    end
  end
  ```

+ Interpreting and running the above code in iex

  ```sh
  $ iex geometry.ex
  iex(1)> Geometry.rectangle_area(6, 7)
  42
  ```

+ Module must be defined in single file. A single file can contain multiple modules.
+ Module names must start with uppercase character. Convention Pascalcase (Camelcase starting with uppercase).
+ Modules can be nested.

#### 2.3.2 Functions

+ Naming convention - snake case. Functions that return boolean end with **?**, functions that raise runtime errors end with **!**.
+ Function definition

  ```elixir
  defmodule Geometry do
    def rectangle_area(a, b) do
      ...
    end

    def run do # functions without parameters can omit parentheses.
      rectangle_area(2, 3) # Module name can be omitted if calling in the same module.
    end

    def rectangle_area(a, b), do: a * b # Condensed form
  end
  ```

  > *defmodule* and *def* are not keywords but macros.
+ Parentheses are optional while invoking functions, but always include them for the sake of clarity.
+ **Pipeline operator** - `-5 |> abs |> Integer.to_string |> IO.puts`.
This code is transformed at runtime into - `IO.puts(Integer.to_string(abs(-5)))`.

  More generally, the pipeline operator places the result of the previous call as the first
  argument of the next call. So the following code `prev(arg1, arg2) |> next(arg3, arg4)` is translated at compile time to `next(prev(arg1, arg2), arg3, arg4)`.

### 2.3.3 Functional Arity

+ Functional arity is number of arguments a function receives. Two functions with same name but different arities are different functions. It usually makes no sense for different functions with a same name to have completely different implementations. More commonly, a lower-arity function delegates to
a higher-arity function, providing some default arguments.
+ Default arguments - provided by using `\\` operator followed by default value.

  ```elixir
  defmodule Calculator do
    def sum(a, b \\ 0) do
      a + b
    end
  end
  ```

  > Note that default values generate multiple functions of the same name with different arities.
  > So the previous code generates two functions: `Calculator.sum/1` and `Calculator.sum/2`.

### 2.3.4 Function Visibility

```elixir
defmodule TestPrivate do
  def double(a) do # public function
    sum(a, a)
  end

  defp sum(a, b) do # private function
    a + b
  end
end
```

### 2.3.5 Imports and Aliases

```elixir
defmodule MyModule do
  import IO # import IO module

  def my_function do
    puts "Calling imported function." # Use puts from IO modules without module name.
  end
end
```

  > The standard library's `Kernel` module is automatically imported into every module.

+ alias

  ```elixir
    defmodule MyModule do
      alias IO, as: MyIO # import IO as MyIO

      def my_function do
        MyIO.puts("Calling imported function.") # use MyIO as qualifier
      end
    end
  ```
