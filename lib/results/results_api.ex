defmodule Results.ResultsApi do
  @moduledoc """
  
    ResultsApi is intended to be the only interaction point whit the app, 
    accessing other modules directly is highly discouraged.

  """

  @doc """

  get all results related to the league and season provided.

  Returns `{:ok, result}` if the result exists, `:notfound` if not found
  or `:error` otherwise.
  """
  def get(league, season) do
    Results.LeagueSeasonDb.get(league, season)
  end

  @doc """
  Looks up for all the league season pairs available.

  Returns `{:ok, [LeagueSeason]}` or `:error` otherwise.
  """
  def list_leagues() do
    Results.LeagueSeasonDb.list_leagues_seasons()
  end

  @doc """
  insert or update the given result for league and season provided.

  Returns `{:ok, result}`, `:notfound` or `:error` otherwise.
  """
  def put(league, season, %Result{} = result) do
    Results.LeagueSeasonDb.put(league, season, result)
  end

  @doc """
  set database status.

  when database is "loading" queries will fail

  Returns `:ok` or `:error`.
  """
  def set_db_status(status) do
    Results.LeagueSeasonDb.set_status(status)
  end

  @doc """
  get database status.

  when database is "loading" queries will fail

  Returns `:ok` or `:error`.
  """
  def checkdb do
    case Results.LeagueSeasonDb.get_status() do
      {:ok, :ok} ->
        :ok

      _ ->
        :error
    end
  end
end
