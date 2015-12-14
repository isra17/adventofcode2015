defmodule NiceRules1 do
  @first_rule ~r/[aeiou]/
  @second_rule ~r/(.)\1/
  @third_rule ~r/ab|cd|pq|xy/

  def count(data) do
    data
      |> Enum.filter(fn l -> length(Regex.scan(@first_rule, l)) >= 3 end)
      |> Enum.filter(fn l -> Regex.match?(@second_rule, l) end)
      |> Enum.filter(fn l -> !Regex.match?(@third_rule, l) end)
      |> length
  end
end

defmodule NiceRules2 do
  @first_rule ~r/(..).*\1/
  @second_rule ~r/(.).\1/

  def count(data) do
    data
      |> Enum.filter(fn l -> Regex.match?(@first_rule, l) end)
      |> Enum.filter(fn l -> Regex.match?(@second_rule, l) end)
      |> length
  end
end

data = IO.stream(:stdio, :line) |> Enum.map(&String.rstrip(&1))

IO.puts("==== Day 5 ====")
IO.puts("Nice strings following first ruleset: #{NiceRules1.count(data)}")
IO.puts("Nice strings following second ruleset: #{NiceRules2.count(data)}")

