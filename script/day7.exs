defmodule SantaVM do
  require Bitwise

  def compile(lines) do
    Enum.reduce(lines, HashDict.new, fn(line, vm) ->
      toks = String.split(line)
      o = List.last(toks)
      Dict.put(vm, o,
        case Enum.slice(toks, 0, length(toks)-2) do
          [a] -> {&ops_yield(&1, &2), a, nil}
          [a, "AND", b ] -> {&ops_and/2, a, b}
          [a, "OR", b ] -> {&ops_or/2, a, b}
          [a, "LSHIFT", n] -> {&ops_lshift(&1, to_i(n), &2), a, nil}
          [a, "RSHIFT", n] -> {&ops_rshift(&1, to_i(n), &2), a, nil}
          ["NOT", a] -> {&ops_not(&1, &2), a, nil}
        end)
    end)
  end

  def eval(state, nil) do
    {state, nil}
  end

  def eval(state = {vm, cache}, endpoint) do
    case Dict.fetch(cache, endpoint) do
      {:ok, n} -> {state, n}
      :error ->
        case Dict.get(vm, endpoint) do
          {ops, a, b} ->
            {state, a} = eval(state, a)
            {{_, cache}, b} = eval(state, b)
            n = u16(ops.(a, b))
            {{vm, Dict.put(cache, endpoint, n)}, n}
          nil -> {state, u16(to_i(endpoint))}
        end
    end
  end

  def to_i(x) do String.to_integer x end
  def u16(n) do << x :: unsigned-size(16) >> = << n :: size(16) >>; x end

  def ops_yield(a, _) do a end
  def ops_and(a, b) do Bitwise.band(a, b) end
  def ops_or(a, b) do Bitwise.bor(a, b) end
  def ops_lshift(a, n, _) do Bitwise.bsl(a, n) end
  def ops_rshift(a, n, _) do Bitwise.bsr(a, n) end
  def ops_not(a, _) do Bitwise.bnot(a) end
end

data = IO.stream(:stdio, :line) |> Enum.map(&String.rstrip/1)
vm = SantaVM.compile(data)
{_, a_value} = SantaVM.eval({vm, HashDict.new}, "a")
cache = Dict.put(HashDict.new, "b", a_value)
{_, a_override_value} = SantaVM.eval({vm, cache}, "a")

IO.puts("==== Day 7 ====")
IO.puts("a value: #{a_value}")
IO.puts("a value (b overriden): #{a_override_value}")
