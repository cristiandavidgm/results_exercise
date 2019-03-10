defmodule ExprotobufTest do
  use ExUnit.Case
  alias Results.Exprotobuf.Data.ResultMsg
  alias Results.Exprotobuf.Data.ResultsMsg
  alias Results.Exprotobuf.Data.LeagueSeasonMsg
  alias Results.Exprotobuf.Data.LeaguesSeasonsMsg
  require Logger

  test "can define structs from proto file" do
    assert %ResultMsg{id: "1", date: "19/08/2016"}.id == "1"

    result1 = %ResultMsg{
      id: "1",
      date: "19/08/2016",
      home_team: "La Coruna",
      away_team: "Eibar",
      fthg: "2",
      ftag: "1",
      tfr: "H",
      htgh: "0",
      htag: "0",
      htr: "D"
    }

    result2 = %ResultMsg{
      id: "2",
      date: "19/08/2016",
      home_team: "Malaga",
      away_team: "Osasuna",
      fthg: "1",
      ftag: "1",
      tfr: "D",
      htgh: "0",
      htag: "0",
      htr: "D"
    }

    results = %ResultsMsg{results: [result1, result2]}

    binary = Protobuf.Encoder.encode(results, ResultsMsg.defs())
    results_decoded = Protobuf.Decoder.decode(binary, ResultsMsg)

    result1_decoded = Enum.at(results_decoded.results, 0)
    result2_decoded = Enum.at(results_decoded.results, 1)

    # Logger.info "Decoded result: #{inspect(result1_decoded)}"

    assert result1_decoded.id == "1"
    assert result2_decoded.home_team == "Malaga"

    league1 = %LeagueSeasonMsg{
      league: "SP1",
      season: "201617"
    }

    league2 = %LeagueSeasonMsg{
      league: "SP2",
      season: "201718"
    }

    leagues = %LeaguesSeasonsMsg{leagues: [league1, league2]}

    binary = Protobuf.Encoder.encode(leagues, LeaguesSeasonsMsg.defs())
    leagues_decoded = Protobuf.Decoder.decode(binary, LeaguesSeasonsMsg)

    league1_decoded = Enum.at(leagues_decoded.leagues, 0)
    league2_decoded = Enum.at(leagues_decoded.leagues, 1)

    # Logger.info "Decoded result: #{inspect(result1_decoded)}"

    assert league1_decoded.league == "SP1"
    assert league2_decoded.season == "201718"
  end
end
