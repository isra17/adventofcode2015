defmodule PassGen do
  def next(<< ?z, rest :: binary>>) do << ?a >> <> next(rest) end

  def next(<< x, rest :: binary>>) do << x+1 >> <> rest end

  def rule1(p = <<a,b,c, _ :: binary>>) do
    if a == b+1 and a == c+2 do
      true
    else
      << _, rest :: binary >> = p
      rule1(rest)
    end
  end

  def rule1(_) do false end

  def rule2(p) do not Regex.match?(~r/[iol]/, p) end

  def rule3(p) do
    1 < Regex.scan(~r/(.)\1/, p)
    |> Enum.map(fn([_,x]) -> x end)
    |> Enum.reduce(HashSet.new, &(HashSet.put(&2,&1)))
    |> Set.size
  end

  def valid?(password) do
    rule2(password) and
    rule1(password) and
    rule3(password)
  end

  def next_valid(password) do
    if valid?(password) do
      password
    else
      next_valid(next(password))
    end
  end

  def next_pass(old) do
    old
      |> String.reverse
      |> next
      |> next_valid
      |> String.reverse
  end
end

data = String.rstrip(IO.read(:stdio, :line))
next_pass = PassGen.next_pass(data)
next_pass2 = PassGen.next_pass(next_pass)

IO.puts("==== Day 11 ====")
IO.puts("Next valid password: #{next_pass}")
IO.puts("Next valid password: #{next_pass2}")
