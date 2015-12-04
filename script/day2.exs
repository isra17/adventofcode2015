
data = IO.stream(:stdio, :line)
  |> Enum.map(fn l ->
      Regex.run(~r/(.+)x(.+)x(.+)/, l) |> tl
        |> Enum.map(&(elem Integer.parse(&1), 0))
  end)

paper_qty = data
  |> Enum.map(fn [l,w,h] ->
    sides = [l*w,w*h,h*l]
    Enum.sum(sides) * 2 + Enum.min(sides)
  end)
  |> Enum.sum

ribbon_qty = data
  |> Enum.map(&Enum.sort/1)
  |> Enum.map(fn [l,w,h] -> l*2 + w*2 + l*w*h end)
  |> Enum.sum

IO.puts("==== Day 2 ====")
IO.puts("Paper needed: #{paper_qty}")
IO.puts("Ribbon needed: #{ribbon_qty}")
