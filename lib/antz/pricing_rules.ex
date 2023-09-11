defmodule Antz.PricingRules do
  defmodule BuyOneGetOneFree do
    def apply(product_order) do
      ((product_order.count - div(product_order.count, 2)) |> round()) * product_order.price
    end
  end

  defmodule BulkDiscount do
    defstruct [:min_quantity, :discounted_price]

    def apply(product_order, rule) do
      if product_order.count >= rule.min_quantity do
        product_order.count * rule.discounted_price
      else
        product_order.total
      end
    end
  end

  defmodule PercentageDiscount do
    defstruct [:min_quantity, :discount_percentage]

    def apply(product_order, rule) do
      if product_order.count >= rule.min_quantity do
        product_order.price * rule.discount_percentage * product_order.count
      else
        product_order.total
      end
    end
  end
end
