defmodule PlugSignature.Crypto do
  @moduledoc """
  This module exposes the cryptographic core functions used in HTTP signatures.
  These functions may be used to implement clients, or alternative server-side
  implementations, e.g. for Raxx.

  Supported algorithms:

    * 'hs2019', using ECDSA, RSASSA-PSS or HMAC (all with SHA-512)
    * 'rsa-sha256', using RSASSA-PKCS1-v1_5
    * 'rsa-sha1', using RSASSA-PKCS1-v1_5
    * 'ecdsa-sha256'
    * 'hmac-sha256'
  """

  require Record

  Record.defrecordp(
    :rsa_public_key,
    :RSAPublicKey,
    Record.extract(:RSAPublicKey, from_lib: "public_key/include/OTP-PUB-KEY.hrl")
  )

  Record.defrecordp(
    :rsa_private_key,
    :RSAPrivateKey,
    Record.extract(:RSAPrivateKey, from_lib: "public_key/include/OTP-PUB-KEY.hrl")
  )

  Record.defrecordp(
    :ec_private_key,
    :ECPrivateKey,
    Record.extract(:ECPrivateKey, from_lib: "public_key/include/OTP-PUB-KEY.hrl")
  )

  Record.defrecordp(
    :ecdsa_signature,
    :"ECDSA-Sig-Value",
    Record.extract(:"ECDSA-Sig-Value", from_lib: "public_key/include/OTP-PUB-KEY.hrl")
  )

  @doc """
  Verifies a signature value. Raises in case of errors.
  """
  def verify!(payload, "hs2019", signature, rsa_public_key(publicExponent: e, modulus: n)) do
    # Use PSS padding; requires workaround for https://bugs.erlang.org/browse/ERL-878
    :crypto.verify(:rsa, :sha512, payload, signature, [e, n], rsa_padding: :rsa_pkcs1_pss_padding)
  end

  def verify!(payload, "hs2019", signature, {_point, _ecpk_parameters} = public_key) do
    signature = der_ecdsa_signature(signature)

    :public_key.verify(payload, :sha512, signature, public_key)
  end

  def verify!(payload, "hs2019", signature, hmac_secret) when is_binary(hmac_secret) do
    signature == hmac_fun(:sha512, hmac_secret, payload)
  end

  def verify!(payload, "rsa-sha256", signature, rsa_public_key() = public_key) do
    # Use PKCS1-v1_5 padding (default)
    :public_key.verify(payload, :sha256, signature, public_key)
  end

  def verify!(payload, "rsa-sha1", signature, rsa_public_key() = public_key) do
    # Use PKCS1-v1_5 padding (default)
    :public_key.verify(payload, :sha, signature, public_key)
  end

  def verify!(payload, "ecdsa-sha256", signature, {_point, _ecpk_parameters} = public_key) do
    signature = der_ecdsa_signature(signature)

    :public_key.verify(payload, :sha256, signature, public_key)
  end

  def verify!(payload, "hmac-sha256", signature, hmac_secret) when is_binary(hmac_secret) do
    signature == hmac_fun(:sha256, hmac_secret, payload)
  end

  def verify(payload, algorithm, signature, public_key) do
    {:ok, verify!(payload, algorithm, signature, public_key)}
  rescue
    _ -> {:error, "bad algorithm or key"}
  end

  # Not all ECDSA implementations wrap the signature in ASN.1; some just
  # return the raw curve coordinates (r and s) concattenated as binaries;
  # so we convert to ASN.1 DER format if necessary
  defp der_ecdsa_signature(signature) do
    case is_der_ecdsa_signature?(signature) do
      true ->
        signature

      false ->
        size = signature |> byte_size() |> div(2)
        <<r::size(size)-unit(8), s::size(size)-unit(8)>> = signature
        :public_key.der_encode(:"ECDSA-Sig-Value", ecdsa_signature(r: r, s: s))
    end
  end

  defp is_der_ecdsa_signature?(signature) do
    _ = :public_key.der_decode(:"ECDSA-Sig-Value", signature)
    true
  rescue
    MatchError -> false
  end

  @doc """
  Generates a signature. Raises in case of an error.
  """
  def sign!(payload, "hs2019", rsa_private_key(publicExponent: e, modulus: n, privateExponent: d)) do
    # Use PSS padding; requires workaround for https://bugs.erlang.org/browse/ERL-878
    :crypto.sign(:rsa, :sha512, payload, [e, n, d], rsa_padding: :rsa_pkcs1_pss_padding)
  end

  def sign!(payload, "hs2019", ec_private_key() = private_key) do
    :public_key.sign(payload, :sha512, private_key)
  end

  def sign!(payload, "hs2019", hmac_secret) when is_binary(hmac_secret) do
    hmac_fun(:sha512, hmac_secret, payload)
  end

  def sign!(payload, "rsa-sha256", rsa_private_key() = private_key) do
    # Use PKCS1-v1_5 padding (default)
    :public_key.sign(payload, :sha256, private_key)
  end

  def sign!(payload, "rsa-sha1", rsa_private_key() = private_key) do
    # Use PKCS1-v1_5 padding (default)
    :public_key.sign(payload, :sha, private_key)
  end

  def sign!(payload, "ecdsa-sha256", ec_private_key() = private_key) do
    :public_key.sign(payload, :sha256, private_key)
  end

  def sign!(payload, "hmac-sha256", hmac_secret) when is_binary(hmac_secret) do
    hmac_fun(:sha256, hmac_secret, payload)
  end

  @doc """
  Generates a signature.

  Returns `{:ok, signature}` or `{:error, reason}`.
  """
  def sign(payload, algorithm, private_key) do
    {:ok, sign!(payload, algorithm, private_key)}
  rescue
    _ -> {:error, "bad algorithm or key"}
  end

  # TODO: remove when we require OTP 22.1
  if Code.ensure_loaded?(:crypto) and function_exported?(:crypto, :mac, 4) do
    defp hmac_fun(digest, key, payload), do: :crypto.mac(:hmac, digest, key, payload)
  else
    defp hmac_fun(digest, key, payload), do: :crypto.hmac(digest, key, payload)
  end
end
