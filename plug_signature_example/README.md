# PlugSignatureExample

Application demonstrating the use of `PlugSignature` and `PlugBodyDigest` for
HTTP request authentication.

## Starting the application

Before starting the application for the first time, ensure the necessary
dependencies have been installed using `mix deps.get`.

Run the application using `mix run --no-halt` or `iex -S mix`. The server
listens on port 4040.

## OpenSSL/cURL client

A bash script called `request.sh` may be used to trigger a number of
scenarios that demonstrate the functionality provided by `PlugSignature` and
`PlugBodyDigest`. The script is invoked as `request.sh [<scenario> [<method>]]`.

Scenarios:

  * `valid` (default) - make a valid request, signed using ECDSA
  * `expired` - make a request with a 10 minute old signature, resulting in a
    401 response
  * `digest` - make a request with an checksum in the Digest header that does
    not match the request body, resulting in a 403 response
  * `key` - make a request with an unknown keyId, resulting in a 401 response
  * `headers` - make a request with a signature that does not cover the
    minimum set of required headers, resulting in a 401 response
  * `signature` - make a request with an invalid sigature value, resulting in
    a 401 response
  * `rsa` - make a valid request, signed using RSASSA-PSS
  * `hmac` - make a valid request, using HMAC authentication

The optional second argument selects the request method: `post` (default) or
`get`.

The output shows the HTTP request headers, including the Digest and
Authorization headers, as well as response headers and body.

## Tesla client

To use the Tesla client, start an IEx session with `iex -S mix`, the create a
client and send requests to the server as follows:

```elixir
iex> client = PlugSignatureExample.Client.new("ec.pub", "priv/ec.key")
%Tesla.Client{
  # ...
}
iex> PlugSignatureExample.Client.get(client, %{test: 123})
{:ok,
 %Tesla.Env{
  # ...
  status: 200,
  # ...
 }
}
iex> PlugSignatureExample.Client.post(client, %{test: 123})
{:ok,
 %Tesla.Env{
  # ...
  status: 200,
  # ...
 }
}
```
