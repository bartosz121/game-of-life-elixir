defmodule GameOfLife.Server do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def evolve(game_server) do
    GenServer.call(game_server, :evolve)
  end

  @impl GenServer
  def init(_) do
    board = GameOfLife.Game.new(10)
    # IO.inspect(board)
    {:ok, board}
  end

  @impl GenServer
  def handle_call(:evolve, _, board) do
    new_state = GameOfLife.Game.evolve(board)
    # IO.inspect(new_state)
    {:reply, new_state, new_state}
  end
end
