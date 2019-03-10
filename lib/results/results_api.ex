defmodule Results.ResultsApi do
  def get(league, season) do
    Results.LeagueSeasonDb.get(league, season)
  end

  def list_leagues() do
    Results.LeagueSeasonDb.list_leagues_seasons()
  end

  def put(league, season, %Result{} = result) do
    Results.LeagueSeasonDb.put(league, season, result)
  end

  def set_db_status(status) do
    Results.LeagueSeasonDb.set_status(status)
  end

  def checkdb do
    case Results.LeagueSeasonDb.get_status() do
      {:ok, :ok} ->
        :ok

      _ ->
        :error
    end
  end
end
