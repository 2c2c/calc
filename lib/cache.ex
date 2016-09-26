defmodule Calc.Cache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :cache)
  end

  def lookup(pid, action) do
    GenServer.call(pid, {:lookup, action})
  end

  def push(pid, item) do
    GenServer.call(pid, {:push, item})
  end


  def handle_call({:lookup, action}, _from, state) do
    value = cache_seek(state, action)

    {:reply, value, state}
  end

  def handle_call({:push, item}, _from, state) do
    new_state = [item | state]

    {:reply, :ok, new_state}
  end

  def handle_call({:history, max}, _from, state) do
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
