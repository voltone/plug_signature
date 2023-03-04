defmodule PlugSignature.SignatureStringTest do
  use ExUnit.Case
  doctest PlugSignature.SignatureString

  # Test cases derived from IETF compliance test
  # https://github.com/w3c-dvcg/http-signatures-test-suite

  # For valid options MUST return a valid signature string
  test "valid" do
    assert {:ok, string} =
             build(
               "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nDate: Tue, 07 Jan 2020 12:16:59 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "date"
             )

    assert string == "date: Tue, 07 Jan 2020 12:16:59 GMT"
  end

  # If a value is not the last value then append an ASCII newline
  test "multi-header" do
    assert {:ok, string} =
             build(
               "POST /foo?param=value&pet=dog HTTP/1.1\nHost: example.com\nContent-Type: application/json\nDigest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=\nContent-Length: 18\nDate: Tue, 07 Jan 2020 12:17:00 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "digest host"
             )

    assert string ==
             "digest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=\nhost: example.com"
  end

  # SHOULD accept lowercase and uppercase HTTP header fields
  test "mixed case" do
    assert {:ok, string} =
             build(
               "POST /foo?param=value&pet=dog HTTP/1.1\nhoSt: example.com\ncontent-Type: application/json\nDIgest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=\nContent-LenGth: 18\nDate: Tue, 07 Jan 2020 12:17:00 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "content-length host digest"
             )

    assert string ==
             "content-length: 18\nhost: example.com\ndigest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE="
  end

  # SHOULD be a lowercased, quoted list of HTTP header fields, separated by a
  # single space character"
  test "headers parameter" do
    assert {:ok, string} =
             build(
               "POST /foo?param=value&pet=dog HTTP/1.1\nHost: example.com\nContent-Type: application/json\nDigest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=\nContent-Length: 18\nDate: Tue, 07 Jan 2020 12:17:00 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "content-length host digest"
             )

    assert string ==
             "content-length: 18\nhost: example.com\ndigest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE="
  end

  # The client MUST use the values of each HTTP header field in the headers
  # Signature Parameter, in the order they appear in the headers Signature
  # Parameter
  test "order" do
    assert {:ok, string} =
             build(
               "POST /foo?param=value&pet=dog HTTP/1.1\nHost: example.com\nContent-Type: application/json\nDigest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=\nContent-Length: 18\nDate: Tue, 07 Jan 2020 12:17:01 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "content-length host"
             )

    assert string ==
             "content-length: 18\nhost: example.com"
  end

  # All header field values associated with the header field MUST be
  # concatenated, separated by an ASCII comma and an ASCII space, and used in
  # the order in which they will appear in the transmitted HTTP message
  test "duplicate" do
    assert {:ok, string} =
             build(
               "GET /duplicate/headers HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nHost: example.com\nDuplicate: one, two\nAuthorization: Signature algorithm=\"hmac\"\nfirst: first\nlast: last\nDate: Tue, 07 Jan 2020 12:17:01 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "host duplicate"
             )

    assert string ==
             "host: example.com\nduplicate: one, two"
  end

  # If a header specified in the headers parameter cannot be matched with a
  # provided header in the message, the implementation MUST produce an error
  test "missing" do
    assert {:error, "could not build signature_string"} =
             build(
               "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nDate: Tue, 07 Jan 2020 12:17:01 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "not-in-request"
             )
  end

  # If a header specified in the headers parameter is malformed the
  # implementation MUST produce an error
  test "malformed" do
    assert {:error, "could not build signature_string"} =
             build(
               "POST /foo?param=value&pet=dog HTTP/1.1\nHost: example.com\nContent-Type: application/json\nDigest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=\nContent-Length: 18\nDate: Tue, 07 Jan 2020 12:17:02 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "digest=="
             )
  end

  # If the header value is a zero-length string, the signature string line
  # correlating with that header will simply be the (lowercased) header name,
  # an ASCII colon :, and an ASCII space
  test "empty value" do
    assert {:ok, string} =
             build(
               "POST /foo?param=value&pet=dog HTTP/1.1\nHost: example.com\nZero:   \nContent-Type: application/json\nDigest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=\nContent-Length: 18\nDate: Tue, 07 Jan 2020 12:17:02 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "zero"
             )

    assert string ==
             "zero: "
  end

  # SHOULD change capitalized Headers to lowercase
  test "lower case result" do
    assert {:ok, string} =
             build(
               "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nDate: Tue, 07 Jan 2020 12:17:02 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "connection"
             )

    assert string ==
             "connection: keep-alive"
  end

  # If the header field name is '(request-target)' then generate the header
  # field value by concatenating the lowercased :method, an ASCII space, and
  # the :path pseudo-header
  test "(request-target)" do
    assert {:ok, string} =
             build(
               "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nDate: Tue, 07 Jan 2020 12:17:02 GMT\n\n{\"hello\": \"world\"}\n",
               headers: "(request-target)"
             )

    assert string ==
             "(request-target): get /basic/request"
  end

  # SHOULD return \"\" if the headers paramter is empty
  test "empty" do
    assert {:ok, string} =
             build(
               "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nDate: Tue, 07 Jan 2020 12:17:03 GMT\n\n{\"hello\": \"world\"}\n",
               headers: ""
             )

    assert string ==
             ""
  end

  # If the header parameter is not specified, implementations MUST operate as
  # if the field were specified with a single value, '(created)', in the list
  # of HTTP headers
  test "default" do
    assert {:ok, string} =
             build(
               "POST /foo?param=value&pet=dog HTTP/1.1\nHost: example.com\nContent-Type: application/json\nDigest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=\nContent-Length: 18\nAuthorization: Signature keyId=\"foo\",created=1,headers=\"(created)\",signature=\"test\"\nDate: Tue, 07 Jan 2020 12:17:03 GMT\n\n{\"hello\": \"world\"}\n",
               created: "1578399423"
             )

    assert string ==
             "(created): 1578399423"
  end

  # name: "If (created) is in headers & the algorithm param starts with rsa MUST produce an error"
  # mode: "canonicalize"
  # opts: [headers: "(rsa)"]
  # input: "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nAuthorization: Signature keyId=\"foo\",algorithm=\"rsa\",created=1,headers=\"(created)\",signature=\"test\"\nDate: Tue, 07 Jan 2020 12:17:03 GMT\n\n{\"hello\": \"world\"}\n"
  # result: false

  # name: "If (created) is in headers & the algorithm param starts with hmac MUST produce an error"
  # mode: "canonicalize"
  # opts: [headers: "(hmac)"]
  # input: "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nAuthorization: Signature keyId=\"foo\",algorithm=\"hmac\",headers=\"(created)\",signature=\"test\",created=1\nDate: Tue, 07 Jan 2020 12:17:04 GMT\n\n{\"hello\": \"world\"}\n"
  # result: false

  # name: "If (created) is in headers & the algorithm param starts with ecdsa MUST produce an error"
  # mode: "canonicalize"
  # opts: [headers: "(ecdsa)"]
  # input: "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nAuthorization: Signature keyId=\"foo\",algorithm=\"ecdsa\",created=1,headers=\"(created)\",signature=\"test\"\nDate: Tue, 07 Jan 2020 12:17:04 GMT\n\n{\"hello\": \"world\"}\n"
  # result: false

  # name: "If the 'created' Signature Parameter is not specified, an implementation MUST produce an error"
  # mode: "canonicalize"
  # opts: [headers: "(created)"]
  # input: "Date: Tue, 07 Jan 2020 12:17:04 GMT\n\n{\"hello\": \"world\"}\n"
  # result: false

  # name: "If the created Signature Parameter is not an integer or unix timestamp, an implementation MUST produce an error
  # mode: "canonicalize"
  # opts: [headers: "(created)", created: "not-an-integer"]
  # input: "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nDate: Tue, 07 Jan 2020 12:17:05 GMT\n\n{\"hello\": \"world\"}\n"
  # result: false

  # name: "If given valid options SHOULD return '(created)'"
  # mode: "canonicalize"
  # opts: [headers: "(created)", created: "1578399415"]
  # input: "POST /foo?param=value&pet=dog HTTP/1.1\nHost: example.com\nContent-Type: application/json\nDigest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=\nContent-Length: 18\nAuthorization: Signature keyId=\"foo\",created=1,headers=\"(created)\",signature=\"test\"\nDate: Tue, 07 Jan 2020 12:17:05 GMT\n\n{\"hello\": \"world\"}\n"
  # result: "(created): 1578399415"

  # name: "If (expires) is in headers & the algorithm param starts with rsa MUST produce an error"
  # mode: "canonicalize"
  # opts: [headers: "(rsa)"]
  # input: "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nAuthorization: Signature keyId=\"foo\",algorithm=\"rsa\",created=1,headers=\"(created)\",signature=\"test\"\nDate: Tue, 07 Jan 2020 12:17:05 GMT\n\n{\"hello\": \"world\"}\n"
  # result: false

  # name: "If (expires) is in headers & the algorithm param starts with hmac MUST produce an error"
  # mode: "canonicalize"
  # opts: [headers: "(hmac)"]
  # input: "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nAuthorization: Signature keyId=\"foo\",algorithm=\"hmac\",headers=\"(created)\",signature=\"test\",created=1\nDate: Tue, 07 Jan 2020 12:17:05 GMT\n\n{\"hello\": \"world\"}\n"
  # result: false

  # name: "If (expires) is in headers & the algorithm param starts with ecdsa MUST produce an error"
  # mode: "canonicalize"
  # opts: [headers: "(ecdsa)"]
  # input: "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nAuthorization: Signature keyId=\"foo\",algorithm=\"ecdsa\",created=1,headers=\"(created)\",signature=\"test\"\nDate: Tue, 07 Jan 2020 12:17:06 GMT\n\n{\"hello\": \"world\"}\n"
  # result: false

  # name: "If the 'expires' Signature Parameter is not specified, an implementation MUST produce an error"
  # mode: "canonicalize"
  # opts: [headers: "(expires)"]
  # input: "Date: Tue, 07 Jan 2020 12:17:06 GMT\n\n{\"hello\": \"world\"}\n"
  # result: false

  # name: "If the expires Signature Parameter is not an integer or unix timestamp, an implementation MUST produce an error"
  # mode: "canonicalize"
  # opts: [headers: "(expires)", expires: "not-an-integer"]
  # input: "GET /basic/request HTTP/1.1\nConnection: keep-alive\nUser-Agent: Mozilla/5.0 (Macintosh)\nDate: Tue, 07 Jan 2020 12:17:06 GMT\n\n{\"hello\": \"world\"}\n"
  # result: false

  # name: "If given valid options SHOULD return '(expires)'"
  # mode: "canonicalize"
  # opts: [headers: "(expires)", expires: "1578400027"]
  # input: "POST /foo?param=value&pet=dog HTTP/1.1\nHost: example.com\nContent-Type: application/json\nDigest: SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=\nContent-Length: 18\nAuthorization: Signature keyId=\"foo\",expires=0,headers=\"(created)\",signature=\"test\"\nDate: Tue, 07 Jan 2020 12:17:07 GMT\n\n{\"hello\": \"world\"}\n"
  # result: "(expires): 1578400027"

  defp build(input, opts) do
    header_list = opts |> Keyword.get(:headers, "(created)") |> String.split(" ", trim: true)
    PlugSignature.SignatureString.build(conn(input), opts, "hs2019", header_list)
  end

  defp conn(input) do
    http = String.replace(input, "\n", "\r\n")
    {method, path_and_query, _version, more} = :cow_http.parse_request_line(http)
    {headers, _body} = :cow_http.parse_headers(more)

    {request_path, query_string} =
      case String.split(path_and_query) do
        [path] -> {path, ""}
        [path, query] -> {path, query}
      end

    host =
      case List.keyfind(headers, "host", 0) do
        {"host", host} -> host
        nil -> nil
      end

    %Plug.Conn{
      host: host || "www.example.com",
      method: method,
      request_path: request_path,
      query_string: query_string,
      req_headers: headers
    }
  end
end
