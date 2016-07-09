prefix = fn pref1 ->
  &("#{pref1} #{&1}")

  # following is the longer form of above
  # fn pref2 ->
  #   "#{pref1} #{pref2}"
  # end
end

IO.inspect prefix.("Elixir").("Rocks")
