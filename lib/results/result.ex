defmodule Result do
  @derive {Jason.Encoder,
           only: [:id, :date, :home_team, :away_team, :fthg, :ftag, :tfr, :htgh, :htag, :htr]}
  @enforce_keys [:id]
  defstruct id: nil,
            date: nil,
            home_team: nil,
            away_team: nil,
            fthg: nil,
            ftag: nil,
            tfr: nil,
            htgh: nil,
            htag: nil,
            htr: nil
end
