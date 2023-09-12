defmodule Antz.ProductOrder do
  @moduledoc """
  A module for representing product orders and applying pricing discounts.

  The `Antz.ProductOrder` module defines a struct for product orders,
  including information such as the product code, unit price, quantity, sub-total, and total price.
  It also provides functionality to apply pricing discounts to product orders based on various pricing rules.

  ## Struct Definition

  A product order is represented as a struct with the following fields:
  - `product_code`: The code of the product being ordered.
  - `unit_price`: The unit price of the product.
  - `quantity`: The quantity of the product being ordered.
  - `sub_total`: The sub-total price before applying discounts.
  - `discount`: The discount amount applied to the sub-total.
  - `total`: The total price after applying discounts.
  """

  @type t() :: %__MODULE__{
          product_code: String.t(),
          unit_price: float(),
          quantity: pos_integer(),
          sub_total: pos_integer(),
          total: pos_integer()
        }

  alias Antz.PricingRules.{BuyGetFree, BulkDiscount, PercentageDiscount}

  defstruct [:product_code, :unit_price, :quantity, sub_total: 0.0, discount: 0.0, total: 0.0]

  def new(product, quantity, rule) do
    total = product.price * quantity

    %__MODULE__{
      product_code: product.code,
      unit_price: product.price,
      quantity: quantity,
      sub_total: total,
      total: total
    }
    |> apply_discount(rule)
  end

  def product_order_with_discount(product_order, new_total) do
    %__MODULE__{
      product_order
      | discount: (product_order.sub_total - new_total) |> round_value(),
        total: new_total |> round_value()
    }
  end

  defp apply_discount(product_order, %BuyGetFree{} = rule) do
    new_total = BuyGetFree.apply(product_order, rule)
    product_order_with_discount(product_order, new_total)
  end

  defp apply_discount(product_order, %BulkDiscount{} = rule) do
    new_total = BulkDiscount.apply(product_order, rule)
    product_order_with_discount(product_order, new_total)
  end

  defp apply_discount(product_order, %PercentageDiscount{} = rule) do
    new_total = PercentageDiscount.apply(product_order, rule)
    product_order_with_discount(product_order, new_total)
  end

  defp apply_discount(product_order, _), do: product_order

  defp round_value(value) do
    value |> Decimal.from_float() |> Decimal.round(2) |> Decimal.to_float()
  end
end
