defmodule Calc do
  use Application

  @spec add(number, number) :: number
  def add(x,y) do
    Process.sleep(1_000)
    x + y
  end

  @spec sub(number, number) :: number
  def sub(x,y) do
    Process.sleep(1_000)
    x - y
  end

  def start(_type, _args) do
    Calc.Supervisor.start_link
  end

end
