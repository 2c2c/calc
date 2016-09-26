defmodule Calc.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts)
  end

  def init(opts) do
    children = [
      supervisor(Calc.ServerSupervisor, [[], [name: :server_supervisor]]),
      worker(Calc.Cache, [[], [name: :cache]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
