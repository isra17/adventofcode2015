defmodule SantaMap do
  def parse_map(line, map) do
    [a, _, b, _, d] = String.split(line)
    d = String.to_integer(d)
    map
      |> Dict.put(a, Dict.get(map, a, []) ++ [{b, d}])
      |> Dict.put(b, Dict.get(map, b, []) ++ [{a, d}])
  end

  def shortest_paths(map, neighboor, distance, visited, p) do
    res = neighboor
      |> Enum.filter(fn({c,_}) -> not c in visited end)
      |> Enum.map(fn({c, d}) ->
        shortest_paths(map, Dict.fetch!(map, c), distance + d, visited ++ [c], p)
      end)

    case res do
      [] -> distance
      n -> p.(n)
    end
  end
end

map = IO.stream(:stdio, :line) |> Enum.map(&String.rstrip/1)
  |> Enum.reduce(HashDict.new, &SantaMap.parse_map/2)

shortest_path =
    SantaMap.shortest_paths( map, Enum.map(Dict.keys(map), &({&1,0})), 0, [], &Enum.min/1)
longest_path =
    SantaMap.shortest_paths( map, Enum.map(Dict.keys(map), &({&1,0})), 0, [], &Enum.max/1)


IO.puts("==== Day 9 ====")
IO.puts("Shortest route: #{shortest_path}")
IO.puts("Longest route: #{longest_path}")

