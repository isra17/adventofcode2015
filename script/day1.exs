case IO.read(:stdio, :line) do
  data ->
    input = to_char_list String.rstrip(data)
    # from becojo
    floor = input |> Enum.map(&([{40, 1}, {41, -1}][&1])) |> Enum.sum

    # This one is mine!
    basement = input
      |> Enum.map_reduce(0, fn x, f -> f = f + ([{40, 1}, {41, -1}][x]); {f,f} end)
      |> elem(0) |> Enum.find_index(fn x -> x == -1 end)

    IO.puts("==== Day 1 ====")
    IO.puts("Floor at the end: #{floor}")
    IO.puts("Time to hit basement: #{basement}")
end
