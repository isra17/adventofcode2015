defmodule Santa do
  def move(94, {x,y}) do {x,y+1} end
  def move(118, {x,y}) do {x,y-1} end
  def move(62, {x,y}) do {x+1,y} end
  def move(60, {x,y}) do {x-1,y} end
end

case IO.read(:stdio, :line) do
  data ->
    input = to_char_list String.rstrip(data)
    visited = input
      |> Enum.reduce({HashSet.new, {0,0}},
        fn direction, {visited, current} ->
          next = Santa.move(direction, current)
          {Set.put(visited, next), next}
        end) |> elem(0)
      |> Set.size

    robot_santa_visited = input
      # Split the input into 2 lists
      |> Enum.chunk(2) |> Enum.map(&List.to_tuple/1) |> Enum.unzip
      # Process both list
      |> Tuple.to_list |> Enum.map(fn direction ->
        Enum.reduce(direction, {HashSet.new, {0,0}},
          fn direction, {visited, current} ->
            next = Santa.move(direction, current)
            {Set.put(visited, next), next}
          end) |> elem(0)
        end)
      # Merge both set
      |> Enum.reduce(HashSet.new, &Set.union/2)
      |> Set.size

    IO.puts("House visited: #{visited}")
    IO.puts("House visited with robot: #{robot_santa_visited}")
end

