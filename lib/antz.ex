defmodule Antz do
  @moduledoc """
  A module for managing product orders in a simple command-line interface (CLI).

  The `Antz` module provides a basic command-line interface for creating and managing product orders.
  Users can add products to an order, view available products, and proceed to checkout.
  The CLI displays product details, order summaries, and total prices.
  Remember to enter the product's code and the quantity (optional)
  """

  alias Antz.Order
  alias Antz.Product

  def main(_args) do
    print_header()
    loop(Order.new())
  end

  defp loop(order) do
    print_products()
    order_summary(order, "Order Summary:")

    [input, quantity] =
      IO.gets(">> ")
      |> String.trim()
      |> String.split(" ")
      |> parse_input()

    case input do
      "exit" ->
        nil

      "checkout" ->
        checkout(order)

      code ->
        add_product(order, code, quantity)
    end
  rescue
    _ ->
      print_with_color(:red_background, "Invalid Input. Please try again.")
      loop(order)
  end

  defp parse_input([code]), do: [code, nil]

  defp parse_input([code, quantity]) do
    [code, String.to_integer(quantity)]
  end

  defp print_header do
    print_with_color(
      :green_background,
      """
      - Enter code and quantity to add a product to the order.
      - Enter 'checkout' to process order.
      - Enter 'exit' to close the program.
      """
    )
  end

  defp print_products do
    print_with_color(:blue_background, "Available products:")

    Enum.each(Product.list_products(), fn product ->
      print_with_color(
        :cyan_background,
        "#{product.code}: #{product.name} - #{product.price} €"
      )
    end)
  end

  defp add_product(order, code, quantity) do
    case Product.find_by_code(code) do
      nil ->
        print_with_color(:red_background, "Invalid product code. Please try again.")
        loop(order)

      product ->
        quantity = quantity || 1

        Order.add_product(order, product, quantity)
        |> loop()
    end
  end

  defp checkout(order) do
    order_summary(order, "Order Details:")
    print_with_color(:blue_background, "Total price: #{order.total} €")
    start_again()
  end

  defp order_summary(order, label) do
    IO.puts(label)

    IO.puts(
      "#{format_c("code")}#{format_c("price")}#{format_c("count")}#{format_c("subtotal")}#{format_c("discount")}#{format_c("total")}"
    )

    order.product_orders
    |> Enum.each(fn p_order ->
      IO.puts(
        "#{format_c(p_order.product_code)}#{format_c(p_order.unit_price)}#{format_c(p_order.quantity)}#{format_c(p_order.sub_total)}#{format_c(p_order.discount)}#{format_c(p_order.total)}"
      )
    end)
  end

  defp start_again() do
    print_with_color(
      :green_background,
      "Enter 'new' for start a new order, or anything else to close."
    )

    input = IO.gets(">> ") |> String.trim()

    case input do
      "new" -> loop(Order.new())
      _ -> IO.puts("Bye!")
    end
  end

  defp format_c(element) do
    "|#{element} #{String.duplicate(" ", 15)}" |> String.slice(0..14)
  end

  defp print_with_color(color, content) do
    IO.ANSI.format([color, content]) |> IO.puts()
  end
end
