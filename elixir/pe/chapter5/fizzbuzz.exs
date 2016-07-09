# Write a program that prints the numbers from 1 to 100.
# But for multiples of three print “Fizz” instead of the number and
# for the multiples of five print “Buzz”.
# For numbers which are multiples of both three and five print “FizzBuzz”.

fizz_word = fn
  0, 0, _ -> "FizzBuzz"
  0, _, _ -> "Fizz"
  _, 0, _ -> "Buzz"
  _, _, n -> n
end

fizzbuzz = fn (n) ->
  fizz_word.(rem(n, 3), rem(n, 5), n)
end

IO.inspect Enum.map(1..100, fizzbuzz)
