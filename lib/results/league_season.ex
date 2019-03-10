defmodule LeagueSeason do
  @derive {Jason.Encoder, only: [:league, :season]}
  defstruct league: nil,
            season: nil
end
