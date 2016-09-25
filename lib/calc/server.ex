defmodule Calc.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def add(pid, x, y) do
    GenServer.call(pid, {:add, x, y})
  end

  def sub(pid, x, y) do
    GenServer.call(pid, {:sub, x, y})
  end

  def handle_call({:add, x, y}, from, state) do
    # if cached, skip calculation
    cached_value = cache_seek(state, %{op: "add", params: [x, y]})
    if cached_value == nil do
      result = Calc.add(x, y)
    else
      result = cached_value.result
    end

    {:reply, result, [%{op: "add", params: [x, y], result: result} | state]}
  end

  def handle_call({:sub, x, y}, from, state) do
    # if cached, skip calculation
    cached_value = cache_seek(state, %{op: "sub", params: [x, y]})
    if cached_value == nil do
      result = Calc.sub(x, y)
    else
      result = cached_value.result
    end

    {:reply, result, [%{op: "sub", params: [x, y], result: result} | state]}
  end

  def handle_call({:history, max}, from, state) do
    history =
      state
      |> Enum.take(max)
      |> Enum.map(fn(x) -> "#{x.op}: #{inspect x.params} -> #{x.result}" end)

    {:reply, history, state}
  end
  defp cache_seek(state, new_action) do
    state
    |> Enum.find(fn(x) -> equiv?(x, new_action) end)
  end
  defp equiv?(a,b) do
    (a.op == b.op) && (Enum.sort(a.params) == Enum.sort(b.params))
  end
end
