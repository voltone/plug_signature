# PlugSignature

[![Github.com](https://github.com/voltone/plug_signature/workflows/CI/badge.svg)](https://github.com/voltone/plug_signature/actions)
[![Hex.pm](https://img.shields.io/hexpm/v/plug_signature.svg)](https://hex.pm/packages/plug_signature)
[![Hexdocs.pm](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/plug_signature/)
[![Hex.pm](https://img.shields.io/hexpm/dt/plug_signature.svg)](https://hex.pm/packages/plug_signature)
[![Hex.pm](https://img.shields.io/hexpm/l/plug_signature.svg)](https://hex.pm/packages/plug_signature)
[![Github.com](https://img.shields.io/github/last-commit/voltone/plug_signature.svg)](https://github.com/voltone/plug_signature/commits/master)

Plug for verifying request signatures according to the IETF HTTP signatures
[draft specification](https://tools.ietf.org/html/draft-cavage-http-signatures-12).

Supports the following algorithms:

  * "hs2019", using ECDSA, RSASSA-PSS or HMAC
  * "rsa-sha256", using RSASSA-PKCS1-v1_5
  * "ecdsa-sha256"
  * "hmac-sha256"
  * "rsa-sha1", using RSASSA-PKCS1-v1_5

Development and public release of this package were made possible by
[Bluecode](https://bluecode.com/).

The HTTP Date header parsing module was vendored from
[cowlib](https://github.com/ninenines/cowlib), due to build issues that
prevented use of the package as a dependency. Cowlib is copyright (c)
2013-2018, Loïc Hoguin

## Usage

Use `PlugSignature` in a Phoenix (or other Plug-based) application.

Requests with a valid signature are allowed to proceed while all others are
rejected. Both the success and the failure behaviour can be customized.

`PlugSignature` requires a callback module that implements the
`PlugSignature.Callback` behaviour. In a Phoenix application this would
typically live in a 'context' module, and it might look something like this:

```elixir
defmodule MyApp.Auth do
  import Ecto.Query, only: [from: 2]

  alias MyApp.Repo
  alias MyApp.Auth.AccessKey

  @behaviour PlugSignature.Callback

  @impl true
  def client_lookup(key_id, "hs2019", _conn) do
    query = from a in AccessKey,
      where: a.key_id == ^key_id,
      preload: :client

    case Repo.one(query) do
      nil ->
        {:error, "Invalid access key ID: #{key_id}"}

      {:ok, %AccessKey{revoked: true}} ->
        {:error, "Access key revoked: #{key_id}"}

      {:ok, %AccessKey{public_key: pem, client: client}} ->
        public_key = plug_signature.PublicKey.from_pem!(pem)
        {:ok, client, public_key}
    end
  end
end
```

To enable verification of the request body, through the HTTP Digest header,
add `PlugBodyDigest` from the [plug_body_digest](https://hex.pm/packages/plug_body_digest)
package, e.g. to the application's Phoenix Endpoint:

```elixir
defmodule MyAppWeb.Endpoint do
  # ...

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library(),
    body_reader: {PlugBodyDigest, :digest_body_reader, []}

  plug PlugBodyDigest
end
```

Finally, add `PlugSignature`, for instance to a Phoenix Router pipeline:

```elixir
defmodule MyAppWeb.Router do
  # ...

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugSignature,
      callback_module: MyApp.Auth,
      headers: "(request-target) (created) host digest",
      on_success: {PlugSignature, :assign_client, [:client]}
  end

  # ...
end
```

Alternatively it may be used inside a controller's pipeline, possibly with
guards:

```elixir
defmodule MyAppWeb.SomeController do
  use MyAppWeb, :controller

  plug PlugSignature, [
    callback_module: MyApp.Auth,
    headers: "(request-target) (created) host digest"
  ] when not action in [:show, :index]

  # ...
end
```

The directory `plug_signature_example` in the package source repository
contains a minimal functional sample application, implemented as a simple Plug
server that echos back the request parameters after signature authentication.

## Client implementation

The sample application includes clients written in Elixir, using Tesla
middleware, and as a shell script, using OpenSSL and cURL.

## Installation

Add `plug_signature` to your list of dependencies in `mix.exs` (and consider
adding `plug_body_digest` as well):

```elixir
def deps do
  [
    {:plug_body_digest, "~> 0.5.0"},
    {:plug_signature, "~> 0.6.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/plug_signature](https://hexdocs.pm/plug_signature).

## License

Copyright (c) 2019, Bram Verburg
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its contributors
  may be used to endorse or promote products derived from this software
  without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
