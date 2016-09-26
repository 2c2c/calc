defmodule Calc.Server do
  use GenServer

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def add(pid, x, y) do
    GenServer.call(pid, {:add, x, y})
  end

  def sub(pid, x, y) do
    GenServer.call(pid, {:sub, x, y})
  end

  def history(num_items) do
    GenServer.call(:cache, {:history, num_items})
  end

  def handle_call({:add, x, y}, _from, state) do
    # if cached, skip calculation
    cached_value = Calc.Cache.lookup(:cache, %{op: "add", params: [x, y]})
    if cached_value == nil do
      result = Calc.add(x, y)
      new_cached_item = %{op: "add", params: [x, y], result: result}
      Calc.Cache.push(:cache, new_cached_item)
    else
      result = cached_value.result
    end

    {:reply, result, []}
  end

  def handle_call({:sub, x, y}, _from, state) do
    # if cached, skip calculation
    cached_value = Calc.Cache.lookup(:cache, %{op: "sub", params: [x, y]})
    if cached_value == nil do
      result = Calc.sub(x, y)
      new_cached_item = %{op: "sub", params: [x, y], result: result}
      Calc.Cache.push(:cache, new_cached_item)
    else
      result = cached_value.result
    end

    {:reply, result, []}
  end
end
