defmodule LightsManager do
  @parsing_re ~r/(toggle|turn off|turn on) (\d+),(\d+) through (\d+),(\d+)/
  def parse_command(l) do
    [_, action, x1, y1, x2, y2] = Regex.run(@parsing_re, l)
    {String.to_atom(action),
      {Integer.parse(x1) |> elem(0), Integer.parse(y1) |> elem(0)},
      {Integer.parse(x2) |> elem(0), Integer.parse(y2) |> elem(0)}}
  end

  def apply_command({cmd, {x1, y1}, {x2, y2}}, grid) do
    Enum.reduce(x1..x2, grid, fn(x, xgrid) ->
      Enum.reduce(y1..y2, xgrid, fn(y, ygrid) ->
        case cmd do
          :toggle ->
            if Set.member?(ygrid, {x,y}) do
              Set.delete(ygrid, {x,y})
            else
              Set.put(ygrid, {x,y})
            end
          :"turn off" ->
            Set.delete(ygrid, {x,y})
          :"turn on" ->
            Set.put(ygrid, {x,y})
        end
      end)
    end)
  end

  def apply_ancient_nordic_elvish_command({cmd, {x1, y1}, {x2, y2}}, grid) do
    Enum.reduce(x1..x2, grid, fn(x, xgrid) ->
      Enum.reduce(y1..y2, xgrid, fn(y, ygrid) ->
        lumen = Dict.get(ygrid, {x,y}, 0)
        case cmd do
          :toggle ->
            Dict.put(ygrid, {x,y}, lumen+2)
          :"turn off" ->
            Dict.put(ygrid, {x,y}, Enum.max([0, lumen-1]))
          :"turn on" ->
            Dict.put(ygrid, {x,y}, lumen+1)
        end
      end)
    end)
  end
end

data = IO.stream(:stdio, :line)
  |> Enum.map(&String.rstrip/1)
  |> Enum.map(&LightsManager.parse_command/1)

lights_on = data
  |> Enum.reduce(HashSet.new, &LightsManager.apply_command/2)
  |> Set.size

lumens = data
  |> Enum.reduce(HashDict.new, &LightsManager.apply_ancient_nordic_elvish_command/2)
  |> Dict.values
  |> Enum.sum

IO.puts("==== Day 6 (SLOW) ====")
IO.puts("Lights on: #{lights_on}")
IO.puts("Total intensity: #{lumens}")
