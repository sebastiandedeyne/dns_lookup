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
    results =
      records
      |> Enum.map(fn type ->
        Task.async(fn -> get_records(domain, type) end)
      end)
      |> Enum.map(&Task.await/1)
      |> Enum.flat_map(fn 
          {:ok, results} -> results
          {:error, reason} -> [{:error, reason}]
      end)

    error = Enum.find(results, fn 
      {:error, _} -> true
      _ -> false
    end)

    if error != nil do
      {:error, reason} = error
      {:error, reason}
    else
      {:ok, results}
    end
  end
  def get_records(_domain, record) when record not in @records do
    {:error, :invalid_record}
  end
  def get_records(domain, record) do
    case Digger.dig(domain, record) do
      {:ok, results} -> {:ok, Digger.parse(results)}
      {:error, reason} -> {:error, reason}
    end
  end
end
