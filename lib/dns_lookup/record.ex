defmodule DnsLookup.Record do
  defstruct [:name, :ttl, :type, :value]
end
