defmodule Jetray.Routes.ProductsApi do
  import Plug.Conn

  alias Ecto.UUID
  use Plug.Router

  plug(Jetray.Plugs.Cors)
  plug(:match)
  plug(:dispatch)

  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  alias Rath.Products

  get "/products" do
    all_products = Products.get_all()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{data: all_products}))
  end

  get "/products/:id" do
    %Plug.Conn{params: %{"id" => id}} = conn

    case UUID.cast(id) do
      {:ok, uuid} ->
        product = Products.get_product_details(uuid)

        cond do
          is_nil(product) ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(400, Jason.encode!(%{error: "Product not found"}))

          true ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, Jason.encode!(%{data: product}))
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: "Invalid id"}))
    end
  end

  post "/products" do
    # {:ok, body, _conn} = read_body(conn)
    # IO.inspect(body, label: "The data from the client")
    # send_resp(conn, 200, "Got the data: #{body}")

    # {status, body} =
    #   case conn.body_params do
    #     %{"events" => events} ->
    #       {200, process_events(events)}

    #     _ ->
    #       {422, missing_events()}
    #   end

    # Access.fetch(conn.body_params, {status, body})
    {status, body} =
      case conn.body_params do
        %{data: data} ->
          {200, "Got the data and data is #{data}"}

        _ ->
          {422, "Missing data "}
      end

    send_resp(conn, status, body)
  end

  # defp process_events(events) when is_list(events) do
  #   # Do some processing on a list of events
  #   Jason.encode!(%{response: "Received Events!"})
  # end

  # defp process_events(_) do
  #   # If we can't process anything, let them know :)
  #   Jason.encode!(%{response: "Please Send Some Events!"})
  # end

  # defp missing_events do
  #   Jason.encode!(%{error: "Expected Payload: { 'events': [...] }"})
  # end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
