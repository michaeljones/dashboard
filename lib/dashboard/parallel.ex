# Copied from
#
#   http://nathanmlong.com/2014/07/pmap-in-elixir/
#
# and 
#
#   http://elixir-recipes.github.io/concurrency/parallel-map/
#
defmodule Parallel do
  @doc """
      iex> Parallel.map([1,2,3], &(&1*2))
      [2,4,6]
  """
  def map(collection, function) do
    collection
    |> Enum.map(&Task.async(fn -> function.(&1) end))
    # Wait for twenty seconds for completion
    |> Enum.map(&Task.await(&1, 20_000))
  end
end
