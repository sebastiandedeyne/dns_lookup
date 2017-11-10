defmodule DnsLookupTest do
  use ExUnit.Case
  doctest DnsLookup.Digger

  @tag :integration
  test "it can look up dns records" do
    assert 1 == 
      DnsLookup.get_records("google.com", "A")
      |> Enum.filter(fn %DnsLookup.Record{value: value} -> value == "ns1.google.com." end)
      |> Enum.count()
  end
end
