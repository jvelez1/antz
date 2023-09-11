defmodule Antz.ProductTest do
  alias Antz.Product

  use ExUnit.Case

  test "returns products without path input" do
    products = Product.list_products()
    assert products |> Enum.count() == 3
  end

  test "returns error when invalid path" do
    assert Product.list_products("invalid/route") == {:error, :enoent}
  end

  test "return error when invalid struct" do
    assert Product.list_products("data/invalid_products.json") ==
             {:error, :error_parsing_products}
  end
end
