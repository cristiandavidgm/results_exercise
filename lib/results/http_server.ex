defmodule Results.HttpServer do
  use Maru.Server, otp_app: :results
end

defmodule Results.Router.Homepage do
  use Results.HttpServer

  alias Results.Exprotobuf.Data.ResultsMsg
  alias Results.Exprotobuf.Data.LeaguesSeasonsMsg

  version("v1")

  get "json/leagues" do
    {:ok, leagues} = Results.ResultsApi.list_leagues()
    json(conn, %{data: leagues})
  end

  params do
    requires(:league, type: String)
    requires(:season, type: String)
  end

  get "json/results" do
    case Results.ResultsApi.get(params[:league], params[:season]) do
      :not_found ->
        json(conn, %{data: []})

      {:ok, res} ->
        json(conn, %{data: res})
    end
  end

  get "proto/leagues" do
    {:ok, leagues} = Results.ResultsApi.list_leagues()
    leagues_msg = Results.Util.leagues_to_proto(leagues)
    binary = Protobuf.Encoder.encode(leagues_msg, LeaguesSeasonsMsg.defs())

    conn
    |> Plug.Conn.put_resp_content_type("application/octet-stream")
    |> Plug.Conn.send_resp(conn.status || 200, to_string(binary))
    |> Plug.Conn.halt()
  end

  params do
    requires(:league, type: String)
    requires(:season, type: String)
  end

  get "proto/results" do
    results_msg =
      case Results.ResultsApi.get(params[:league], params[:season]) do
        :not_found ->
          %ResultsMsg{results: []}

        {:ok, results} ->
          Results.Util.results_to_proto(results)
      end

    binary = Protobuf.Encoder.encode(results_msg, ResultsMsg.defs())

    conn
    |> Plug.Conn.put_resp_content_type("application/octet-stream")
    |> Plug.Conn.send_resp(conn.status || 200, to_string(binary))
    |> Plug.Conn.halt()
  end

  get "healt_check" do
    case Results.ResultsApi.checkdb() do
      :ok ->
        conn
        |> put_status(200)
        |> text("ok")

      :error ->
        conn
        |> put_status(503)
        |> text("database loading")
    end
  end

  rescue_from Maru.Exceptions.InvalidFormat do
    conn
    |> put_status(400)
    |> text("Bad request")
  end

  rescue_from :all do
    conn
    |> put_status(500)
    |> text("internal server error")
  end

  # rescue_from :all, as: e do
  #   conn
  #   |> put_status(500)
  #   |> text("ERROR: #{inspect(e)}")
  # end
end

defmodule Results.HttpAPI do
  use Results.HttpServer

  plug(Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Jason,
    parsers: [:urlencoded, :json, :multipart]
  )

  mount(Results.Router.Homepage)

  rescue_from :all do
    conn
    |> put_status(500)
    |> text("Server Error")
  end
end
