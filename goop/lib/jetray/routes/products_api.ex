defmodule Jetray.Routes.ProductsApi do
  import Plug.Conn

  alias Ecto.UUID
  use Plug.Router

  plug(Jetray.Plugs.Cors)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  plug(:dispatch)

  alias Rath.Products

  get "/" do
    all_products = Products.get_all()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{data: all_products}))
  end

  get "/:id" do
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

  post "/" do
    data = conn.body_params
    IO.inspect(conn.body_params)

    if not is_nil(data) do
      try do
        new_product =
          case Rath.Mutations.Products.create_product(data) do
            {:create, product} ->
              product
          end

        if new_product do
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(
            200,
            Jason.encode!(%{message: "Created the product ID: #{new_product.id}"})
          )
        else
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{message: "error creating product"}))
        end
      rescue
        e in RuntimeError ->
          conn
          |> put_resp_content_type("application/json")
          |> send_resp(400, Jason.encode!(%{message: e.message}))
      end
    end
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
