# DnsLookup

A wrapper around the `dig` command to look up a domain's dns records in your Elixir application.

```elixir
DnsLookup.get_records("sebastiandedeyne.com", ["A"])
# {:ok, [%DnsLookup.Record{name: "sebastiandedeyne.com.", ttl: 1622, type: "A", value: "188.166.163.155"}]}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dns_lookup` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dns_lookup, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dns_lookup](https://hexdocs.pm/dns_lookup).

