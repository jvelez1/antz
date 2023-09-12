defmodule Antz.Product do
  @moduledoc """
  A module for managing products and their pricing rules.

  The `Antz.Product` module defines a struct for representing products, including fields such as product code, name, price, and pricing rules. It also provides functions for listing products, finding products by code, and parsing product data from a JSON file.

  ## Struct Definition

  A product is represented as a struct with the following fields:
  - `code`: The unique code or identifier for the product.
  - `name`: The name of the product.
  - `price`: The unit price of the product.
  - `rule`: The pricing rule associated with the product, which can be one of `BuyGetFree`, `BulkDiscount`, or `PercentageDiscount`.
  """

  alias Antz.PricingRules
  alias Antz.PricingRules.{BuyGetFree, BulkDiscount, PercentageDiscount}

  @type t() :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          price: float(),
          rule: BuyGetFree.t() | BulkDiscount.t() | PercentageDiscount.t()
        }

  @enforce_keys [:code, :name, :price]
  defstruct [:code, :name, :price, rule: %{}]

  @file_path "data/products.json"

  @spec list_products(String.t()) :: list(t()) | {:error, atom()}
  def list_products(path \\ @file_path) do
    with {:ok, content} <- File.read(path),
         {:ok, raw_products} <- JSON.decode(content),
         {:ok, products} <- build_products(raw_products) do
      products
    end
  end

  @spec list_products(String.t()) :: t() | nil
  def find_by_code(code) do
    list_products()
    |> Enum.find(fn p -> String.upcase(p.code) == String.upcase(code) end)
  end

  defp build_products(raw_products) do
    raw_products
    |> Enum.map(fn product -> build_product(product) end)
    |> then(fn products -> {:ok, products} end)
  rescue
    _error -> {:error, :error_parsing_products}
  end

  defp build_product(%{"code" => code, "name" => name, "price" => price, "rule" => rule}) do
    %__MODULE__{
      code: code,
      name: name,
      price: price,
      rule: parse_pricing_rule(rule)
    }
  end

  defp build_product(_), do: raise("Invalid Data")

  defp parse_pricing_rule(%{"key" => key, "params" => params}) do
    PricingRules.parse(key, params)
  end
end
