defmodule RLE do
  def rle_len(data, count) do
    Enum.reduce(1..count, data, fn(_, input) ->
      Enum.join(Enum.map(Regex.scan(~r/(.)\1*/, input), fn([m,c]) ->
        Integer.to_string(String.length(m)) <> c
      end), "")
    end)
    |> String.length
  end
end
data = String.rstrip(IO.read(:stdio, :line))

len_40 = RLE.rle_len(data, 40)
len_50 = RLE.rle_len(data, 50)

IO.puts("==== Day 10 ====")
IO.puts("RLE len 40 times: #{len_40}")
IO.puts("RLE len 40 times: #{len_50}")

