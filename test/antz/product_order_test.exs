defmodule Antz.ProductOrderTest do
  alias Antz.PricingRules.{BuyGetFree, BulkDiscount, PercentageDiscount}
  alias Antz.{Product, ProductOrder}
  use ExUnit.Case

  describe "new" do
    test "when BuyGetFree rule returns valid total" do
      product = Product.find_by_code("GR1")
      rule = %BuyGetFree{get: 1, free: 1}
      product_order = ProductOrder.new(product, 2, rule)
      assert product_order

      assert product_order.sub_total == 6.22
      assert product_order.discount == 3.11
      assert product_order.total == 3.11
    end

    test "when BulkDiscount rule returns valid total" do
      product = Product.find_by_code("SR1")
      rule = %BulkDiscount{min_quantity: 3, discounted_price: 4.50}
      product_order = ProductOrder.new(product, 3, rule)
      assert product_order

      assert product_order.sub_total == 15.00
      assert product_order.discount == 1.5
      assert product_order.total == 13.5
    end

    test "when PercentageDiscount rule returns valid total" do
      product = Product.find_by_code("CF1")
      rule = %PercentageDiscount{min_quantity: 3, discount_percentage: 2 / 3}
      product_order = ProductOrder.new(product, 3, rule)
      assert product_order

      assert product_order.sub_total == 33.69
      assert product_order.discount == 11.23
      assert product_order.total == 22.46
    end

    test "when invalid rule returns valid total" do
      product = Product.find_by_code("GR1")
      rule = %{}
      product_order = ProductOrder.new(product, 2, rule)
      assert product_order

      assert product_order.sub_total == 6.22
      assert product_order.discount == 0.0
      assert product_order.total == 6.22
    end
  end
end
