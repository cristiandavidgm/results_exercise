defmodule Results.LeagueSeasonDb do
  use GenServer
  ## Client API

  @doc """
  Starts the db server with the given options.

  `:name` is always required.
  """
  def start_link(opts) do
    # 1. Pass the name to GenServer's init
    name = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, name, opts)
  end

  @doc """
  Looks up for all the league season pairs available.

  Returns `{:ok, [LeagueSeason]}` or `:error` otherwise.
  """
  def list_leagues_seasons() do
    GenServer.call(__MODULE__, :list_leagues_seasons)
  end

  @doc """
  Returns all the results related to league and season provided.

  Returns `{:ok, result}` if the result exists, `:notfound` if not found
           or `:error` otherwise.
  """
  def get(league, season) do
    GenServer.call(__MODULE__, {:get, {league, season}})
  end

  @doc """
  insert or update the given result for league and season provided.

  Returns `{:ok, result}`, `:notfound` or `:error` otherwise.
  """
  def put(league, season, result) do
    GenServer.call(__MODULE__, {:put, {league, season, result}})
  end

  @doc """
  set database status.

  when database is "loading" queries will fail

  Returns `{:ok, :ok}` or `{:ok, :loading}`.
  """
  def set_status(status) when status == :ok or status == :loading do
    GenServer.call(__MODULE__, {:set_status, status})
  end

  @doc """
  get database status.

  Returns `{:ok, status}`
  """
  def get_status() do
    GenServer.call(__MODULE__, :get_status)
  end

  ######################
  ## Server callbacks ##
  ######################

  def init(table) do
    # 3. We have replaced the names map by the ETS table
    leagues_seasons =
      :ets.new(table, [:named_table, :ordered_set, :protected, read_concurrency: true])

    Task.Supervisor.async(Results.LoadDbTaskSupervisor, Results.DbLoader, :run, [])

    {:ok, {:ok, leagues_seasons}}
  end

  ## set database status
  def handle_call({:set_status, new_status}, _from, {_db_status, table}) do
    {:reply, :ok, {new_status, table}}
  end

  ## set database status
  def handle_call(:get_status, _from, {db_status, table}) do
    {:reply, {:ok, db_status}, {db_status, table}}
  end

  ## insert a result in the table
  def handle_call({:put, {league, season, result}}, _from, {db_status, table}) do
    put_result(table, league, season, result)
    {:reply, :ok, {db_status, table}}
  end

  ## list all entries in db
  def handle_call(:list_leagues_seasons, _from, {:loading, table}) do
    {:reply, {:error, "database loading"}, {:loading, table}}
  end

  def handle_call(:list_leagues_seasons, _from, {db_status, table}) do
    {:reply, {:ok, list_leagues_seasons(table)}, {db_status, table}}
  end

  def handle_call({:get, _}, _from, {:loading, table}) do
    {:reply, {:error, "database loading"}, {:loading, table}}
  end

  def handle_call({:get, {league, season}}, _from, {:ok, table}) do
    case get_results(table, league, season) do
      {:ok, results} ->
        {:reply, {:ok, MapSet.to_list(results)}, {:ok, table}}

      :not_found ->
        {:reply, :not_found, {:ok, table}}
    end
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  ########################
  ## Internal Functions ##
  ########################

  defp list_leagues_seasons(table) do
    leagues = :ets.match(table, {{:"$1", :"$2"}, :_})
    Enum.map(leagues, fn [league, season] -> %LeagueSeason{league: league, season: season} end)
  end

  defp put_result(table, league, season, result) do
    case get_results(table, league, season) do
      {:ok, results} ->
        new_results = MapSet.put(results, result)
        :ets.insert(table, {{league, season}, new_results})
        :ok

      :not_found ->
        :ets.insert(table, {{league, season}, MapSet.new([result])})
        :ok
    end
  end

  defp get_results(table, league, season) do
    case :ets.lookup(table, {league, season}) do
      [{{_league, _season}, results}] ->
        {:ok, results}

      [] ->
        :not_found
    end
  end
end
