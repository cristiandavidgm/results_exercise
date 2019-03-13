defmodule Results.DbLoader do
  @moduledoc """

    DbLoader is a module that runs in async mode, it is separated from the 
    LeagueSeasonDb module to allow this task to be used after the db has been
    loaded.

  """
  use Task, restart: :transient

  def start_link() do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    Results.ResultsApi.set_db_status(:loading)

    csv_stream =
      Enum.drop(
        Application.app_dir(:results, "priv/Data.csv") |> File.stream!() |> CSV.decode(),
        1
      )

    Enum.each(csv_stream, fn {:ok, row} -> insert_row(row) end)
    Results.ResultsApi.set_db_status(:ok)
  end

  defp insert_row([
         id,
         league,
         season,
         date,
         home_team,
         away_team,
         fthg,
         ftag,
         ftr,
         hthg,
         htag,
         htr
       ]) do
    result = %Result{
      id: id,
      date: date,
      home_team: home_team,
      away_team: away_team,
      fthg: fthg,
      ftag: ftag,
      tfr: ftr,
      htgh: hthg,
      htag: htag,
      htr: htr
    }

    Results.ResultsApi.put(league, season, result)
  end
end
