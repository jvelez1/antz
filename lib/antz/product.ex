defmodule Antz.Product do
  @type t() :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          price: float()
        }

  @enforce_keys [:code, :name, :price]
  defstruct [:code, :name, :price]

  @file_path "data/products.json"

  @spec list_products(String.t()) :: list(t()) | {:error, atom()}
  def list_products(path \\ @file_path) do
    with {:ok, content} <- File.read(path),
         {:ok, raw_products} <- JSON.decode(content),
         {:ok, products} <- build_products(raw_products) do
      products
    end
  end

  defp build_products(raw_products) do
    raw_products
    |> Enum.map(fn product -> build_product(product) end)
    |> then(fn products -> {:ok, products} end)
  rescue
    _error -> {:error, :error_parsing_products}
  end

  defp build_product(%{"code" => code, "name" => name, "price" => price}) do
    %__MODULE__{
      code: code,
      name: name,
      price: price
    }
  end

  defp build_product(_), do: raise("Invalid Data")
end
