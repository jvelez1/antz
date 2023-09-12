defmodule Antz.OrderTest do
  alias Antz.Order
  alias Antz.Product

  use ExUnit.Case

  describe "new" do
    test "return new struct for order" do
      assert Order.new() == %Order{}
    end
  end

  describe "add_product" do
    test "assign product to order with default quantity" do
      product = Product.find_by_code("GR1")
      order = Order.new() |> Order.add_product(product)
      order_product = order.product_orders |> hd()

      assert order_product.product_code == "GR1"
      assert order_product.quantity == 1
      assert order.total == 3.11
    end

    test "assign product to order with custom quantity" do
      product = Product.find_by_code("GR1")
      order = Order.new() |> Order.add_product(product, 2)
      order_product = order.product_orders |> hd()

      assert order.product_orders |> Enum.count() == 1
      assert order_product.product_code == "GR1"
      assert order_product.quantity == 2
    end

    test "assign product to order and calculate total with rule" do
      product = Product.find_by_code("GR1")
      order = Order.new() |> Order.add_product(product, 2)
      order_product = order.product_orders |> hd()
      assert order_product.quantity == 2
      assert order_product.sub_total == 6.22
      assert order_product.discount == 3.11
      assert order.total == 3.11
    end

    test "assign multiple products to order" do
      product1 = Product.find_by_code("GR1")
      product2 = Product.find_by_code("SR1")

      order =
        Order.new()
        |> Order.add_product(product1, 1)
        |> Order.add_product(product2, 3)

      assert order.total == 16.61
    end

    test "assign multiple products to order with and get total with pricing rules" do
      product1 = Product.find_by_code("GR1")
      product2 = Product.find_by_code("SR1")
      product3 = Product.find_by_code("CF1")

      order =
        Order.new()
        |> Order.add_product(product1, 1)
        |> Order.add_product(product2, 1)
        |> Order.add_product(product3, 3)

      assert order.total == 30.57
    end
  end
end
