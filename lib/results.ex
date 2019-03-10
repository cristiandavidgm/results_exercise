defmodule Results do
  use Application

  def start(_type, _args) do
    Results.Supervisor.start_link(name: Results.Supervisor)
  end
end
