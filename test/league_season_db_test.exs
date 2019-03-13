defmodule LeagueSeasonDbTest do
  use ExUnit.Case
  use MecksUnit.Case
  alias Results.Exprotobuf.Data.ResultMsg
  alias Results.Exprotobuf.Data.ResultsMsg
  alias Results.Exprotobuf.Data.LeagueSeasonMsg
  alias Results.Exprotobuf.Data.LeaguesSeasonsMsg
  require Logger

  test "list leagues ok" do
    {:ok, leagues} = Results.LeagueSeasonDb.list_leagues_seasons()

    league1 = hd(leagues)

    assert league1 == ["D1", "201617"]
  end
end
