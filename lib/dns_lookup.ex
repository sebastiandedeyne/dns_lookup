defmodule DnsLookup do
  alias DnsLookup.Digger

  @records [
    "A",
    "AAAA",
    "NS",
    "SOA",
    "MX",
    "TXT",
    "DNSKEY"
  ]

  def get_records(domain, records) when is_list(records) do
    records
    |> Enum.map(&(Task.async(fn -> get_records(domain, &1) end)))
    |> Enum.map(&Task.await/1)
    |> Enum.flat_map(fn 
        {:ok, results} -> results
        {:error, _} -> []
    end)
  end
  def get_records(_domain, record) when record not in @records do
    {:error, :invalid_record}
  end
  def get_records(domain, record) do
    Digger.dig(domain, record)
  end
end
