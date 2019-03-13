defmodule Results.Util do
  @moduledoc """

  All common code belongs here

  """
  alias Results.Exprotobuf.Data.ResultMsg
  alias Results.Exprotobuf.Data.ResultsMsg
  alias Results.Exprotobuf.Data.LeagueSeasonMsg
  alias Results.Exprotobuf.Data.LeaguesSeasonsMsg

  @doc """
  Receives a list of LeagueSeason maps every item in the list to LeagueSeasonMsg

  Returns `[LeagueSeasonMsg]>`
  """
  def leagues_to_proto(leagues) do
    leagues_msgs =
      Enum.map(leagues, fn %LeagueSeason{league: league, season: season} ->
        %LeagueSeasonMsg{league: league, season: season}
      end)

    %LeaguesSeasonsMsg{leagues: leagues_msgs}
  end

  def results_to_proto(results) do
    results_msgs = Enum.map(results, fn result -> result_to_resultmsg(result) end)
    %ResultsMsg{results: results_msgs}
  end

  defp result_to_resultmsg(%Result{
         id: id,
         date: date,
         home_team: home_team,
         away_team: away_team,
         fthg: fthg,
         ftag: ftag,
         tfr: tfr,
         htgh: htgh,
         htag: htag,
         htr: htr
       }) do
    %ResultMsg{
      id: id,
      date: date,
      home_team: home_team,
      away_team: away_team,
      fthg: fthg,
      ftag: ftag,
      tfr: tfr,
      htgh: htgh,
      htag: htag,
      htr: htr
    }
  end
end
