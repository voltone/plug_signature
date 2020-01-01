defmodule PlugSignature.ParserTest do
  use ExUnit.Case
  doctest PlugSignature.Parser

  import PlugSignature.Parser

  test "valid" do
    assert {:ok, params} =
             authorization(
               ~s(Signature keyId=123,signature="0123456789abcdef",created=1562570728)
             )

    assert params[:key_id] == "123"
    assert params[:signature] == "0123456789abcdef"
    assert params[:created] == "1562570728"
  end

  test "extra whitespace" do
    assert {:ok, params} =
             authorization(
               ~s(Signature  keyId=123, signature=  "0123456789abcdef", created = 1562570728)
             )

    assert params[:key_id] == "123"
    assert params[:signature] == "0123456789abcdef"
    assert params[:created] == "1562570728"
  end

  test "duplicate params" do
    assert {:error, "malformed authorization header"} =
             authorization(
               ~s(Signature keyId=123,signature="0123456789abcdef",created=1562570728,keyId=234)
             )
  end

  test "unknown and case mismatch params" do
    assert {:ok, params} =
             authorization(
               ~s(Signature keyColor=red,Signature="0123456789abcdef",created=1562570728)
             )

    refute :keyColor in Keyword.keys(params)
    refute :Signature in Keyword.keys(params)
    refute :signature in Keyword.keys(params)
    assert params[:created] == "1562570728"
  end

  test "weird values with quoted characters" do
    assert {:ok, params} = authorization(~S(Signature keyId="&^%$#@!,{}=\\\""))

    assert params[:key_id] == ~S(&^%$#@!,{}=\")
  end
end
