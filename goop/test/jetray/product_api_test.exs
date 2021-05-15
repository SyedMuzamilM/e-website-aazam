defmodule JetrayTest.ProductApi do
  use ExUnit.Case
  use Plug.Test

  @opts Jetray.Routes.ProductsApi.init([])

  doctest Goop

  # test "Products post request" do
  #   conn = conn(:post, "/api/v1/products", %{event: [%{message: "hello"}]})

  #   # Invoke the plug
  #   conn = Jetray.Routes.ProductsApi.call(conn, @opts)

  #   assert conn.status == 200
  # end

  test "get all the products" do
    conn = conn(:get, "/api/v1/products")

    conn = Jetray.Routes.ProductsApi.call(conn, @opts)

    assert conn.status == 200
  end
end
