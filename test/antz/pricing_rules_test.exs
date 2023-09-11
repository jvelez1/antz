defmodule Antz.PricingRulesTest do
  alias Antz.PricingRules.{BuyOneGetOneFree, BulkDiscount, PercentageDiscount}

  use ExUnit.Case

  describe "BuyOneGetOneFree" do
    test "return new total applying discount" do
      assert BuyOneGetOneFree.apply(%{count: 2, price: 3.11}) == 3.11
    end

    test "return new total applying discount when more invalid orders" do
      assert BuyOneGetOneFree.apply(%{count: 3, price: 3.11}) == 6.22
    end

    test "return new total applying discount when more valid orders" do
      assert BuyOneGetOneFree.apply(%{count: 4, price: 3.11}) == 6.22
    end
  end

  describe "BulkDiscount" do
    test "return new total applying discount" do
      rule = %BulkDiscount{min_quantity: 3, discounted_price: 4.50}
      assert BulkDiscount.apply(%{count: 3, price: 5.00}, rule) == 13.5
    end

    test "return total without discount" do
      rule = %BulkDiscount{min_quantity: 3, discounted_price: 4.50}
      assert BulkDiscount.apply(%{count: 2, price: 5.00, total: 10}, rule) == 10
    end
  end

  describe "PercentageDiscount" do
    test "return new total applying discount" do
      rule = %PercentageDiscount{min_quantity: 3, discount_percentage: 2 / 3}
      assert PercentageDiscount.apply(%{count: 3, price: 11.23}, rule) == 22.46
    end

    test "return total without discount" do
      rule = %PercentageDiscount{min_quantity: 3, discount_percentage: 4.50}
      assert PercentageDiscount.apply(%{count: 2, price: 11.23, total: 22.46}, rule) == 22.46
    end
  end
end
