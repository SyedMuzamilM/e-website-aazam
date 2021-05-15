defmodule Jetray.SocketHandler do
  require Logger

  @type t :: %{
          awaiting_init: boolean(),
          user_id: String.t(),
          encoding: Atom.t(),
          compression: Atom.t()
        }

  defstruct awaiting_init: true,
            user_id: nil,
            encoding: nil,
            compression: nil

  @behaviour :cowboy_websocket

  def init(request, _state) do
    IO.puts(:cowboy_req.parse_qs(request))

    compression =
      request
      |> :cowboy_req.parse_qs()
      |> Enum.find(fn {name, _value} -> name == "compression" end)
      |> case do
        {_name, "zlib_json"} -> :zlib
        {_name, "zlib"} -> :zlib
        _ -> :json
      end

    encoding =
      request
      |> :cowboy_req.parse_qs()
      |> Enum.find(fn {name, _value} -> name == "encoding" end)
      |> case do
        {_name, "etf"} -> :etf
        _ -> :json
      end

    state = %__MODULE__{
      awaiting_init: true,
      user_id: nil,
      encoding: encoding,
      compression: compression
    }

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Process.send_after(self(), {:finish_awaiting}, 10_000)

    {:ok, state}
  end

  def websocket_info({:finish_awaiting}, state) do
    if state.awaiting_init do
      {:stop, state}
    else
      {:ok, state}
    end
  end

  def websocket_info({:remote_send, message}, state) do
    {:reply, ws_send(state.encoding, state.compression, message), state}
  end

  def websocket_info({:send_to_linked_session, message}, state) do
    send(state.linked_session, message)
    {:ok, state}
  end

  def websocket_info({:kill}, state) do
    {:reply, {:close, 4003, "killed_by_server"}, state}
  end

  @doc """
  This handles the messgae "ping" comming from the client
  and replies with the "pong" message
  """
  def websocket_handle({:text, "ping"}, state) do
    {:reply, ws_send(state.encoding, state.compression, "pong"), state}
  end

  def websocket_handle({:ping, _}, state) do
    {:reply, ws_send(state.encoding, state.comptession, "pong"), state}
  end

  def websocket_handle({:text, "fetch_all_products"}, state) do
    products = Rath.Access.Products.get_all()
    IO.inspect(products)

    {:reply,
     ws_send(state.encoding, state.compression, %{
       op: "fetch_all_products",
       d: %{products: products}
     }), state}
  end

  def handler("hola", %{cursor: cursor}, state) do
    {:reply,
     ws_send(state.encoding, state.compression, %{
       op: "hola",
       d: %{message: "hola", initial: cursor == 0}
     }), state}
  end

  defp ws_send(encoding, compression, data) do
    data =
      case encoding do
        :etf ->
          data

        _ ->
          data
          |> Jason.encode!()
      end

    case compression do
      :zlib ->
        z = :zlib.open()
        :zlib.deflateInit(z)

        data = :zlib.deflate(z, data, :finish)

        :zlib.deflateEnd(z)

        {:binary, data}

      _ ->
        {:text, data}
    end
  end
end
