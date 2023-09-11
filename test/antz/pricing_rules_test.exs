defmodule Antz.PricingRulesTest do
  alias Antz.PricingRules.{BuyGetFree, BulkDiscount, PercentageDiscount}

  use ExUnit.Case

  describe "BuyGetFree" do
    test "return new total applying discount" do
      rule = %BuyGetFree{get: 1, free: 1}
      assert BuyGetFree.apply(%{quantity: 2, unit_price: 3.11}, rule) == 3.11
    end

    test "return new total applying discount when more invalid orders" do
      rule = %BuyGetFree{get: 1, free: 1}
      assert BuyGetFree.apply(%{quantity: 3, unit_price: 3.11}, rule) == 6.22
    end

    test "return new total applying discount when more valid orders" do
      rule = %BuyGetFree{get: 1, free: 1}
      assert BuyGetFree.apply(%{quantity: 4, unit_price: 3.11}, rule) == 6.22
    end
  end

  describe "BulkDiscount" do
    test "return new total applying discount" do
      rule = %BulkDiscount{min_quantity: 3, discounted_price: 4.50}
      assert BulkDiscount.apply(%{quantity: 3, unit_price: 5.00}, rule) == 13.5
    end

    test "return total without discount" do
      rule = %BulkDiscount{min_quantity: 3, discounted_price: 4.50}
      assert BulkDiscount.apply(%{quantity: 2, unit_price: 5.00, total: 10}, rule) == 10
    end
  end

  describe "PercentageDiscount" do
    test "return new total applying discount" do
      rule = %PercentageDiscount{min_quantity: 3, discount_percentage: 2 / 3}
      assert PercentageDiscount.apply(%{quantity: 3, unit_price: 11.23}, rule) == 22.46
    end

    test "return total without discount" do
      rule = %PercentageDiscount{min_quantity: 3, discount_percentage: 4.50}

      assert PercentageDiscount.apply(%{quantity: 2, unit_price: 11.23, total: 22.46}, rule) ==
               22.46
    end
  end
end
