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

  def get_records(_domain, record) when record not in @records do
    {:error, :invalid_record}
  end
  def get_records(domain, record) do
    Digger.dig(domain, record)
  end
end
