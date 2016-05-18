# Coma

Yet another CSV library for Elixir!

## Installation

Once I get around to publishing Coma, follow these instructions:

  1. Add coma to your list of dependencies in `mix.exs`:

        def deps do
          [{:coma, "~> 0.0.1"}]
        end

  2. __????PROFIT????__

  <!-- 2. Ensure coma is started before your application:

        def application do
          [applications: [:coma]]
        end -->


## Todo

- [x] CSV Reading
  - [ ] Struct to represent CSV Row
  - [ ] Options for reading headers
- [ ] CSV Writing
- [ ] Read/Write to/from struct rather than supplying a list of values
