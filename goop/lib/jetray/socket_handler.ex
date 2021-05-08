defmodule Jetray.SocketHandler do
  # @behaviour :cowboy_websocket

  def init(request, _state) do
    IO.puts(:cowboy_req.parse_qs(request))

    # check the data
  end
end
