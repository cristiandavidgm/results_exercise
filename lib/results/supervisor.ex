defmodule Results.Supervisor do
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
