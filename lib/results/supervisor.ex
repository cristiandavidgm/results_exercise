defmodule Results.Supervisor do
  @moduledoc """
  The only supervisor in the app.

  It starts the main DB, the HTTP server and creates a Dynamic task supervisor 
  that will be used to start the taks that populated the database.
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {
        Task.Supervisor,
        name: Results.LoadDbTaskSupervisor
      },
      Results.HttpServer,
      {
        Results.LeagueSeasonDb,
        name: Results.LeagueSeasonDb
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
