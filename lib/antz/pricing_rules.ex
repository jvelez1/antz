defmodule Antz.PricingRules do
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
