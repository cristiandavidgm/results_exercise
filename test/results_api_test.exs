defmodule ResultsApiTest do
  use ExUnit.Case
  use MecksUnit.Case
  alias Results.Exprotobuf.Data.ResultMsg
  alias Results.Exprotobuf.Data.ResultsMsg
  alias Results.Exprotobuf.Data.LeagueSeasonMsg
  alias Results.Exprotobuf.Data.LeaguesSeasonsMsg
  require Logger

  defmock Results.LeagueSeasonDb do
    def list_leagues_seasons(),
      do:
        {:ok,
         [
           %LeagueSeason{league: "D1", season: "201617"}
         ]}
  end

  mocked_test "list leagues ok" do
    {:ok, leagues} = Results.ResultsApi.list_leagues()

    league1 = hd(leagues)

    assert league1.league == "D1"
  end

  defmock Results.LeagueSeasonDb do
    def list_leagues_seasons(),
      do: {:ok, []}
  end

  mocked_test "list leagues  empty" do
    {:ok, leagues} = Results.ResultsApi.list_leagues()

    assert Enum.count(leagues) == 0
  end

  defmock Results.LeagueSeasonDb do
    def get(_, _),
      do:
        {:ok,
         [
           %Result{
             away_team: "FC Koln",
             date: "25/02/2017",
             ftag: "1",
             fthg: "3",
             home_team: "RB Leipzig",
             htag: "0",
             htgh: "2",
             htr: "H",
             id: "2260",
             tfr: "H"
           }
         ]}
  end

  mocked_test "get results ok" do
    {:ok, results} = Results.ResultsApi.get("D1", "201617")

    result1 = hd(results)

    assert result1.date == "25/02/2017"
  end

  defmock Results.LeagueSeasonDb do
    def get(_, _),
      do: {:error, "database loading"}
  end

  mocked_test "get results db loading" do
    {status, _} = Results.ResultsApi.get("D1", "201617")

    assert status == :error
  end

  defmock Results.LeagueSeasonDb do
    def put(_, _, %Result{}),
      do: :ok
  end

  mocked_test "put results ok" do
    res = Results.ResultsApi.put("D1", "201617", %Result{id: "1"})
    assert res == :ok
  end

  defmock Results.LeagueSeasonDb do
    def set_status(_), do: :passthroug
    def get_status(), do: :passthroug
  end

  mocked_test "set db status ok" do
    Results.ResultsApi.set_db_status("loading")
    status = Results.ResultsApi.checkdb()
    assert status == :error
  end
end
