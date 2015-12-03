case IO.read(:stdio, :line) do
  data ->
    input = to_char_list String.rstrip(data)
    # from becojo
    part1 = input |> Enum.map(&([{40, 1}, {41, -1}][&1])) |> Enum.sum

    # This one is mine!
    part2 = input
      |> Enum.map_reduce(0, fn x, f -> f = f + ([{40, 1}, {41, -1}][x]); {f,f} end)
      |> elem(0) |> Enum.find_index(fn x -> x == -1 end)

    IO.puts("Part1: #{part1}\nPart2: #{part2}")
end
