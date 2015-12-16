defmodule AdventCoin do

  def mine(prefix, key, n) do
    m = 128-n
    <<hash :: size(n), _ :: size(m)>> =
        :crypto.hash(:md5, prefix <> Integer.to_string(key))
    if hash == 0 do
      key
    else
      mine(prefix, key+1, n)
    end
  end

  def mine(prefix, n) do
    mine(prefix, 0, n*4)
  end
end

k = AdventCoin.mine("abcdef", 5)
IO.puts("k: #{k}")

case IO.read(:stdio, :line) do
  prefix ->
    prefix = String.rstrip(prefix)
    key5 = AdventCoin.mine(prefix, 5)
    key6 = AdventCoin.mine(prefix, 6)

    IO.puts("==== Day 4 ====")
    IO.puts("Key for 5 zeros: #{key5}")
    IO.puts("Key for 6 zeros: #{key6}")
end


