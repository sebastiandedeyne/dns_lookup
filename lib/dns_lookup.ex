defmodule DnsLookup do
  @moduledoc """
  Documentation for DnsLookup.
  """

  alias DnsLookup.Record

  @records [
    "A",
    "AAAA",
    "NS",
    "SOA",
    "MX",
    "TXT",
    "DNSKEY"
  ]

  def get_records(_domain, record) when record not in @records do
    {:error, :invalid_record}
  end
  def get_records(domain, record) do
    fetch_result(domain, record)
  end

  defp fetch_result(domain, record) do
    result = System.cmd("dig", [
      "+nocmd",
      domain,
      record,
      "+multiline",
      "+noall",
      "+answer"
    ])

    case result do
      {"connection timed out; no servers could be reached", 0} -> {:error, :timeout}
      {"", 0} -> {:error, :unknown_host}
      {_, 1} -> {:error, :failed}
      {records, 0} -> {:ok, records}
    end
  end
end
