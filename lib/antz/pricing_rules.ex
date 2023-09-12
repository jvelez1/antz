defmodule Antz.PricingRules do
  @moduledoc """
  A module for defining and applying pricing rules to product orders.

  The `Antz.PricingRules` module provides several pricing rules for calculating the total price of product orders. These rules include buy-get-free promotions, bulk discounts, and percentage discounts.

  ## Pricing Rules

  ### BuyGetFree
  - `get`: The number of products that need to be purchased to qualify for the promotion.
  - `free`: The number of products that will be given for free as part of the promotion.

  This rule calculates the total price by applying a "buy X, get Y free" promotion.

  ### BulkDiscount
  - `min_quantity`: The minimum quantity of products required to qualify for the discount.
  - `discounted_price`: The discounted price per product when the minimum quantity is met.

  This rule calculates the total price by applying a bulk discount for purchasing a certain quantity of products.

  ### PercentageDiscount
  - `min_quantity`: The minimum quantity of products required to qualify for the discount.
  - `discount_percentage`: The percentage discount to be applied to each product.

  This rule calculates the total price by applying a percentage discount to the unit price of each product when the minimum quantity is met.

  ## Usage

  To apply a pricing rule to a product order, you can use the corresponding rule module, such as `Antz.PricingRules.BuyGetFree`, `Antz.PricingRules.BulkDiscount`, or `Antz.PricingRules.PercentageDiscount`. Each rule module provides an `apply/2` function to calculate the total price of a product order based on the rule's criteria.

  Additionally, you can use the `parse/2` function to parse JSON data into rule structs for easy configuration.
  """

  defmodule BuyGetFree do
    defstruct [:get, :free]

    def apply(product_order, rule) do
      div_by = rule.get + rule.free

      ((product_order.quantity - div(product_order.quantity, div_by)) |> round()) *
        product_order.unit_price
    end
  end

  defmodule BulkDiscount do
    defstruct [:min_quantity, :discounted_price]

    def apply(product_order, rule) do
      if product_order.quantity >= rule.min_quantity do
        product_order.quantity * rule.discounted_price
      else
        product_order.total
      end
    end
  end

  defmodule PercentageDiscount do
    defstruct [:min_quantity, :discount_percentage]

    def apply(product_order, rule) do
      if product_order.quantity >= rule.min_quantity do
        product_order.unit_price * rule.discount_percentage * product_order.quantity
      else
        product_order.total
      end
    end
  end

  alias Antz.PricingRules.{BuyGetFree, BulkDiscount, PercentageDiscount}

  def parse("BuyGetFree", %{"get" => get, "free" => free}) do
    %BuyGetFree{
      get: get,
      free: free
    }
  end

  def parse("BulkDiscount", %{
        "discounted_price" => discounted_price,
        "min_quantity" => min_quantity
      }) do
    %BulkDiscount{
      discounted_price: discounted_price,
      min_quantity: min_quantity
    }
  end

  def parse("PercentageDiscount", %{
        "discount_percentage" => discount_percentage,
        "min_quantity" => min_quantity
      }) do
    %PercentageDiscount{
      discount_percentage: discount_percentage,
      min_quantity: min_quantity
    }
  end

  def parse(_, _), do: %{}
end
