defmodule Rath.Products do
  defdelegate get_all(), to: Rath.Access.Products
  defdelegate get_product_details(product_id), to: Rath.Access.Products
end
