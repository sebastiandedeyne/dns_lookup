defmodule DnsLookup.Record do
  defstruct [:type, :name, :value, :ttl]
end
