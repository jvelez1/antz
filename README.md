# Antz CLI

## Description

The Antz CLI is a simple command-line interface for managing product orders. Users can add products to an order, view available products, and proceed to checkout. The CLI displays product details, order summaries, and total prices.

## Requirements

- Optional: Docker
- Elixir 1.15.2 (or higher). if you don't have docker.

## Setup

### Using Docker
If you have Docker installed, you can use the provided setup script to build and run the Antz CLI:

```bash
bin/setup
```

If there is any issue with permissions:

```bash
chmod +x ./bin/setup
```

This script will create a Docker container with the required Elixir environment dependencies and start directly the CLI.

### Manual Setup

If you don't have Docker or prefer manual setup, follow these steps:

- Install Elixir 1.15.2 (or a higher version).
- Install project dependencies:
```bash
mix deps.get
```

- Build the Elixir script into an executable:
```bash
mix escript.build
```

- Usage: To start the Antz CLI, run the following command:
```bash
./antz
```

Once the CLI is running, you can perform the following actions:

- Enter a product code and an optional quantity to add products to the order.
- Enter 'checkout' to process the order and view order details.
- Enter 'exit' to close the program.

For more details and examples, refer to the module documentation and source code.
