defmodule Results.Exprotobuf.Data do
  @moduledoc """
  This Module defines 4 structures bases on the proto file
  	- ResultMsg
  	- ResultsMsg
  	- LeagueSeasonMsg
  	- LeaguesSeasonsMsg

  Those structures will be used by Protobuf module to encode Proto buffer 
  responses.
  """
  use Protobuf, from: Application.app_dir(:results, "priv/results.proto")
end
