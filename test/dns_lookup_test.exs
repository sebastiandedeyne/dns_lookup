defmodule DnsLookupTest do
  use ExUnit.Case
  doctest DnsLookup.Digger

  @tag :integration
  test "it can look up dns records" do
    {:ok, records} = DnsLookup.get_records("google.com", ["NS", "TXT"])

    assert 1 == 
      records
      |> Enum.filter(fn 
        %DnsLookup.Record{type: "NS", value: "ns1.google.com."} -> true 
        _ -> false
      end)
      |> Enum.count()

    assert 1 == 
      records
      |> Enum.filter(fn 
        %DnsLookup.Record{type: "TXT", value: "v=spf1 include:_spf.google.com ~all"} -> true
        _ -> false
      end)
      |> Enum.count()
  end

  @tag :integration
  test "it returns the first error when a batch lookup fails" do
    {:error, error} = DnsLookup.get_records("google.com", ["NS", "TXT", "Z"])

    assert error == :invalid_record
  end
end
