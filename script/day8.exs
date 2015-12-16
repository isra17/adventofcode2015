escape_one = ~r/(\\x[0-9a-f]{2}|\\"|\\\\)/

data = IO.stream(:stdio, :line) |> Enum.map(&String.rstrip/1)
len = Enum.map(data, &String.length/1) |> Enum.sum
unescaped_len = data
  |> Enum.map(fn(l) -> Regex.replace(escape_one, l, "X") end)
  |> Enum.map(&(String.length(&1) - 2))
  |> Enum.sum

escaped_len = data
  |> Enum.map(fn(l) -> String.replace(l, "\\", "\\\\") end)
  |> Enum.map(fn(l) -> String.replace(l, "\"", "\\\"") end)
  |> Enum.map(&(String.length(&1) + 2))
  |> Enum.sum

IO.puts("==== Day 8 ====")
IO.puts("Unescaped diff: #{len - unescaped_len}")
IO.puts("Escaped diff: #{escaped_len - len}")

