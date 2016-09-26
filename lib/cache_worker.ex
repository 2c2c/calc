defmodule Calc.CacheWorker do
  defp cache_seek(state, new_action) do
    state
    |> Enum.find(fn(x) -> equiv?(x, new_action) end)
  end

  defp equiv?(a,b) do
    (a.op == b.op) && (Enum.sort(a.params) == Enum.sort(b.params))
  end
end
