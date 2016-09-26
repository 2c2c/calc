defmodule Calc.ServerSupervisor do
  use Supervisor

  @pool_name :server_pool

  def start_link(state, opts \\ []) do
    Supervisor.start_link(__MODULE__, state, opts)
  end

  def init(opts) do
    poolboy_config = [
      {:name, {:local, @pool_name}},
      {:worker_module, Calc.Server},
      {:size, 2},
      {:max_overflow, 1}
    ]

    children = [
      :poolboy.child_spec(@pool_name, poolboy_config, [])
    ]

    supervise(children, strategy: :one_for_one)
  end

  def add(x, y) do
    func = fn(pid) -> Calc.Server.add(pid, x, y) end
    pooled_command(func)
  end

  def sub(x, y) do
    func = fn(pid) -> Calc.Server.sub(pid, x, y) end
    pooled_command(func)
  end

  def history(num_items) do
      func = fn(pid) -> Calc.Server.history(num_items) end
      pooled_command(func)
  end

  defp pooled_command(func) do
    :poolboy.transaction(
      @pool_name,
      func,
      :infinity
    )
  end
end
