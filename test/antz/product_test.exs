defmodule Antz.ProductTest do
  alias Antz.Product
  alias Antz.PricingRules.BuyGetFree

  use ExUnit.Case

  test "returns products without path input" do
    products = Product.list_products()
    assert products |> Enum.count() == 3
  end

  test "returns products with rule definition" do
    product = Product.list_products() |> hd()
    assert product.rule
    assert product.rule == %BuyGetFree{get: 1, free: 1}
  end

  test "returns error when invalid path" do
    assert Product.list_products("invalid/route") == {:error, :enoent}
  end

  test "return error when invalid struct" do
    assert Product.list_products("data/invalid_products.json") ==
             {:error, :error_parsing_products}
  end

  describe "find_by_code" do
    test "return valid product" do
      product = Product.find_by_code("SR1")
      assert product.code == "SR1"
    end

    test "return valid product with upcase" do
      product = Product.find_by_code("sr1")
      assert product.code == "SR1"
    end

    test "return nil when not found upcase" do
      assert Product.find_by_code("jojo") == nil
    end
  end
end
