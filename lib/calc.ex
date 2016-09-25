defmodule Calc do
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
end
