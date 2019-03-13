defmodule LeagueSeason do
  @moduledoc """
  Defines the structure used to model league-season pairs, derives Jason.Encoder
  which is used by maru to encode json results
  """
  @derive {Jason.Encoder, only: [:league, :season]}
  defstruct league: nil,
            season: nil
end
