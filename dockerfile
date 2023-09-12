# Use the official Elixir image as the base image
FROM elixir:1.15.4-alpine

# Create and set the working directory
WORKDIR /app

# Copy the Elixir project files (including mix.exs and mix.lock) to the container
COPY mix.exs mix.lock ./

# Install project dependencies (mix deps.get) without docs
RUN mix deps.get
RUN mix deps.compile

# Copy the rest of the application code to the container
COPY . .

RUN mix escript.build