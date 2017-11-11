defmodule DnsLookup.Digger do
  @moduledoc false

  def dig(domain, record) do
    results = System.cmd("dig", [
      "+nocmd",
      domain,
      record,
      "+multiline",
      "+noall",
      "+answer",
      "+time=4"
    ])

    case results do
      {";; connection timed out; no servers could be reached\n", 9} -> {:error, :timeout}
      {"", 0} -> {:error, :unknown_host}
      {_, 1} -> {:error, :failed}
      {results, 0} -> {:ok, results}
    end
  end

  @doc """
  ## Examples

      iex> ~s(sebastiandedeyne.com.\\t1622 IN\\tA 188.166.163.155\\n)
      ...> |> DnsLookup.Digger.parse()
      [%DnsLookup.Record{name: "sebastiandedeyne.com.", ttl: 1622, type: "A", value: "188.166.163.155"}]

      iex> ~s(google.com.\\t21599 IN\\tNS ns1.google.com.\\ngoogle.com.\\t21599 IN\\tNS ns2.google.com.\\n)
      ...> |> DnsLookup.Digger.parse()
      [
        %DnsLookup.Record{name: "google.com.", ttl: 21599, type: "NS", value: "ns1.google.com."},
        %DnsLookup.Record{name: "google.com.", ttl: 21599, type: "NS", value: "ns2.google.com."}
      ]

      iex> ~s(google.com.\\t3570 IN\\tTXT "v=spf1 include:_spf.google.com ~all"\\n)
      ...> |> DnsLookup.Digger.parse()
      [%DnsLookup.Record{name: "google.com.", ttl: 3570, type: "TXT", value: "v=spf1 include:_spf.google.com ~all"}]
  """
  def parse(records) do
    records
    |> String.split("\n")
    |> Enum.reject(&empty?/1)
    |> Enum.map(&parse_record/1)
  end

  defp parse_record(record) do
    [name, ttl, _, type, value] = 
      record
      |> String.replace(~r/[ \t]+/, " ")
      |> String.trim("\n")
      |> String.split(" ", parts: 5)
      |> Enum.reject(&empty?/1)

    %DnsLookup.Record{name: name, ttl: String.to_integer(ttl), type: type, value: String.trim(value, ~s("))}
  end

  defp empty?(""), do: true
  defp empty?(_), do: false
end
