defmodule GameOfLife.Game do
  @moduledoc """
  GameOfLife.Game

  Cell state:
    - 0 -> dead
    - 1 -> alive
  """
  @doc """
  Creates new board with random dead/alive cells.
  Board size: `board_size` x `board_size`
  """
  def new(board_size) do
    for _ <- 1..board_size do
      Enum.map(1..board_size, fn _ ->
        Enum.random(0..1)
      end)
    end
  end

  def evolve(board) do
    board
    |> Stream.with_index()
    |> Stream.map(fn {row, row_i} ->
      row
      |> Stream.with_index()
      |> Stream.map(fn {cell, col_i} ->
        neighbours_count =
          Stream.map(
            [
              {row_i - 1, col_i},
              {row_i - 1, col_i + 1},
              {row_i, col_i + 1},
              {row_i + 1, col_i + 1},
              {row_i + 1, col_i},
              {row_i + 1, col_i - 1},
              {row_i, col_i - 1},
              {row_i - 1, col_i - 1}
            ],
            fn {y, x} ->
              if y >= 0 and x >= 0 do
                case Enum.fetch(board, y) do
                  {:ok, row} -> Enum.at(row, x, 0)
                  _ -> 0
                end
              else
                0
              end
            end
          )
          |> Enum.count(fn n -> n == 1 end)

        case {cell, neighbours_count} do
          {1, 2} -> 1
          {1, 3} -> 1
          {0, 3} -> 1
          _ -> 0
        end
      end)
      |> Enum.to_list()
    end)
    |> Enum.to_list()
  end
end
