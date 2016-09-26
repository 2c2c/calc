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
    :poolboy.transaction(
      @pool_name,
      fn(pid) -> Calc.Server.add(pid, x, y) end,
      :infinity
    )
  end

  def sub(x, y) do
    :poolboy.transaction(
      @pool_name,
      fn(pid) -> Calc.Server.sub(pid, x, y) end,
      :infinity
    )
  end

  def history(num_items) do
    :poolboy.transaction(
      @pool_name,
      fn(pid) -> Calc.Server.history(num_items) end,
      :infinity
    )
  end
end
