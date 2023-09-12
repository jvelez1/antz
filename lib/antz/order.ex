defmodule Antz.Order do
  alias Antz.Product
  alias Antz.ProductOrder

  @type t() :: %__MODULE__{
          product_orders: list(ProductOrder.t()),
          total: float()
        }

  defstruct product_orders: [], total: 0.0

  @spec new() :: t()
  def new, do: %__MODULE__{}

  @spec add_product(t(), Product.t(), integer()) :: t()
  def add_product(order, product, quantity \\ 1) do
    {found_product_order, current_product_orders} =
      order.product_orders |> Enum.split_with(&(&1.product_code == product.code))

    product_order = init_or_update_product_order(found_product_order, product, quantity)

    %__MODULE__{
      product_orders: current_product_orders ++ [product_order]
    }
    |> calculate_total()
  end

  defp calculate_total(order) do
    %__MODULE__{
      order
      | total:
          order.product_orders
          |> Enum.map(& &1.total)
          |> Enum.sum()
          |> Decimal.from_float()
          |> Decimal.round(2)
          |> Decimal.to_float()
    }
  end

  defp init_or_update_product_order([], product, quantity) do
    ProductOrder.new(product, quantity, product.rule)
  end

  defp init_or_update_product_order([product_order], product, quantity) do
    ProductOrder.new(product, product_order.quantity + quantity, product.rule)
  end
end
