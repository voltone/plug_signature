# Generated from lib/plug_signature/parser.ex.exs, do not edit.
# Generated at 2020-01-01 07:40:41Z.

defmodule PlugSignature.Parser do
  @moduledoc false

  # credo:disable-for-this-file

  @spec authorization_parser(binary, keyword) ::
          {:ok, [term], rest, context, line, byte_offset}
          | {:error, reason, rest, context, line, byte_offset}
        when line: {pos_integer, byte_offset},
             byte_offset: pos_integer,
             rest: binary,
             reason: String.t(),
             context: map()
  defp authorization_parser(binary, opts \\ []) when is_binary(binary) do
    line = Keyword.get(opts, :line, 1)
    offset = Keyword.get(opts, :byte_offset, 0)
    context = Map.new(Keyword.get(opts, :context, []))

    case(authorization_parser__0(binary, [], [], context, {line, offset}, offset)) do
      {:ok, acc, rest, context, line, offset} ->
        {:ok, :lists.reverse(acc), rest, context, line, offset}

      {:error, _, _, _, _, _} = error ->
        error
    end
  end

  defp authorization_parser__0(
         <<"Signature", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__1(rest, [] ++ acc, stack, context, comb__line, comb__offset + 9)
  end

  defp authorization_parser__0(rest, _acc, _stack, context, line, offset) do
    {:error, "expected string \"Signature\"", rest, context, line, offset}
  end

  defp authorization_parser__1(rest, acc, stack, context, line, offset) do
    authorization_parser__5(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__3(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__2(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__4(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__3(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__5(rest, acc, stack, context, line, offset) do
    authorization_parser__6(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__6(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 do
    authorization_parser__7(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__6(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__4(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__7(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 do
    authorization_parser__9(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__7(rest, acc, stack, context, line, offset) do
    authorization_parser__8(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__9(rest, acc, stack, context, line, offset) do
    authorization_parser__7(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__8(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__10(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__10(rest, acc, stack, context, line, offset) do
    authorization_parser__14(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__12(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__11(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__13(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__12(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__14(rest, acc, stack, context, line, offset) do
    authorization_parser__166(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__16(rest, acc, stack, context, line, offset) do
    authorization_parser__17(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__17(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__18(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__17(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__13(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__18(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__20(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__18(rest, acc, stack, context, line, offset) do
    authorization_parser__19(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__20(rest, acc, stack, context, line, offset) do
    authorization_parser__18(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__19(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__22(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__19(rest, acc, stack, context, line, offset) do
    authorization_parser__21(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__22(rest, acc, stack, context, line, offset) do
    authorization_parser__19(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__21(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__23(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__21(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__13(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__23(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__25(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__23(rest, acc, stack, context, line, offset) do
    authorization_parser__24(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__25(rest, acc, stack, context, line, offset) do
    authorization_parser__23(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__24(rest, acc, stack, context, line, offset) do
    authorization_parser__35(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__27(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__28(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__27(rest, _acc, stack, context, line, offset) do
    [_, _, _, _, acc | stack] = stack
    authorization_parser__13(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__28(rest, acc, stack, context, line, offset) do
    authorization_parser__30(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__30(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__31(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__30(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__31(rest, acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__30(rest, acc, stack, context, line, offset) do
    authorization_parser__29(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__29(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__32(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__31(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__30(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__32(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__33(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__32(rest, _acc, stack, context, line, offset) do
    [_, _, _, _, acc | stack] = stack
    authorization_parser__13(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__33(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__26(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__34(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__27(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__35(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__36(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__35(rest, acc, stack, context, line, offset) do
    authorization_parser__34(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__36(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__38(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__36(rest, acc, stack, context, line, offset) do
    authorization_parser__37(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__38(rest, acc, stack, context, line, offset) do
    authorization_parser__36(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__37(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__26(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__26(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__39(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__39(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__15(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__40(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__16(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__41(rest, acc, stack, context, line, offset) do
    authorization_parser__42(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__42(
         <<"headers", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__43(rest, acc, stack, context, comb__line, comb__offset + 7)
  end

  defp authorization_parser__42(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__40(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__43(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__45(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__43(rest, acc, stack, context, line, offset) do
    authorization_parser__44(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__45(rest, acc, stack, context, line, offset) do
    authorization_parser__43(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__44(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__46(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__44(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__40(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__46(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__48(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__46(rest, acc, stack, context, line, offset) do
    authorization_parser__47(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__48(rest, acc, stack, context, line, offset) do
    authorization_parser__46(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__47(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__49(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__49(rest, acc, stack, context, line, offset) do
    authorization_parser__50(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__50(rest, acc, stack, context, line, offset) do
    authorization_parser__60(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__52(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__53(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__52(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__40(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__53(rest, acc, stack, context, line, offset) do
    authorization_parser__55(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__55(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__56(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__55(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__56(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__55(rest, acc, stack, context, line, offset) do
    authorization_parser__54(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__54(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__57(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__56(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__55(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__57(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__58(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__57(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__40(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__58(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__51(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__59(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__52(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__60(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__61(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__60(rest, acc, stack, context, line, offset) do
    authorization_parser__59(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__61(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__63(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__61(rest, acc, stack, context, line, offset) do
    authorization_parser__62(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__63(rest, acc, stack, context, line, offset) do
    authorization_parser__61(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__62(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__51(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__51(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__64(
      rest,
      [headers: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__64(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__15(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__65(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__41(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__66(rest, acc, stack, context, line, offset) do
    authorization_parser__67(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__67(
         <<"expires", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__68(rest, acc, stack, context, comb__line, comb__offset + 7)
  end

  defp authorization_parser__67(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__65(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__68(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__70(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__68(rest, acc, stack, context, line, offset) do
    authorization_parser__69(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__70(rest, acc, stack, context, line, offset) do
    authorization_parser__68(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__69(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__71(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__69(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__65(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__71(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__73(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__71(rest, acc, stack, context, line, offset) do
    authorization_parser__72(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__73(rest, acc, stack, context, line, offset) do
    authorization_parser__71(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__72(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__74(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__74(rest, acc, stack, context, line, offset) do
    authorization_parser__75(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__75(rest, acc, stack, context, line, offset) do
    authorization_parser__85(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__77(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__78(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__77(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__65(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__78(rest, acc, stack, context, line, offset) do
    authorization_parser__80(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__80(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__81(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__80(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__81(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__80(rest, acc, stack, context, line, offset) do
    authorization_parser__79(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__79(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__82(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__81(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__80(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__82(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__83(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__82(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__65(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__83(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__76(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__84(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__77(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__85(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__86(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__85(rest, acc, stack, context, line, offset) do
    authorization_parser__84(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__86(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__88(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__86(rest, acc, stack, context, line, offset) do
    authorization_parser__87(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__88(rest, acc, stack, context, line, offset) do
    authorization_parser__86(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__87(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__76(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__76(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__89(
      rest,
      [expires: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__89(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__15(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__90(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__66(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__91(rest, acc, stack, context, line, offset) do
    authorization_parser__92(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__92(
         <<"created", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__93(rest, acc, stack, context, comb__line, comb__offset + 7)
  end

  defp authorization_parser__92(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__90(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__93(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__95(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__93(rest, acc, stack, context, line, offset) do
    authorization_parser__94(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__95(rest, acc, stack, context, line, offset) do
    authorization_parser__93(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__94(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__96(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__94(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__90(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__96(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__98(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__96(rest, acc, stack, context, line, offset) do
    authorization_parser__97(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__98(rest, acc, stack, context, line, offset) do
    authorization_parser__96(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__97(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__99(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__99(rest, acc, stack, context, line, offset) do
    authorization_parser__100(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__100(rest, acc, stack, context, line, offset) do
    authorization_parser__110(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__102(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__103(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__102(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__90(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__103(rest, acc, stack, context, line, offset) do
    authorization_parser__105(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__105(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__106(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__105(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__106(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__105(rest, acc, stack, context, line, offset) do
    authorization_parser__104(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__104(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__107(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__106(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__105(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__107(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__108(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__107(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__90(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__108(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__101(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__109(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__102(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__110(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__111(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__110(rest, acc, stack, context, line, offset) do
    authorization_parser__109(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__111(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__113(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__111(rest, acc, stack, context, line, offset) do
    authorization_parser__112(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__113(rest, acc, stack, context, line, offset) do
    authorization_parser__111(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__112(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__101(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__101(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__114(
      rest,
      [created: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__114(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__15(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__115(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__91(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__116(rest, acc, stack, context, line, offset) do
    authorization_parser__117(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__117(
         <<"algorithm", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__118(rest, acc, stack, context, comb__line, comb__offset + 9)
  end

  defp authorization_parser__117(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__115(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__118(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__120(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__118(rest, acc, stack, context, line, offset) do
    authorization_parser__119(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__120(rest, acc, stack, context, line, offset) do
    authorization_parser__118(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__119(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__121(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__119(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__115(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__121(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__123(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__121(rest, acc, stack, context, line, offset) do
    authorization_parser__122(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__123(rest, acc, stack, context, line, offset) do
    authorization_parser__121(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__122(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__124(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__124(rest, acc, stack, context, line, offset) do
    authorization_parser__125(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__125(rest, acc, stack, context, line, offset) do
    authorization_parser__135(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__127(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__128(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__127(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__115(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__128(rest, acc, stack, context, line, offset) do
    authorization_parser__130(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__130(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__131(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__130(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__131(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__130(rest, acc, stack, context, line, offset) do
    authorization_parser__129(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__129(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__132(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__131(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__130(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__132(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__133(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__132(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__115(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__133(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__126(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__134(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__127(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__135(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__136(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__135(rest, acc, stack, context, line, offset) do
    authorization_parser__134(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__136(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__138(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__136(rest, acc, stack, context, line, offset) do
    authorization_parser__137(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__138(rest, acc, stack, context, line, offset) do
    authorization_parser__136(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__137(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__126(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__126(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__139(
      rest,
      [algorithm: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__139(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__15(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__140(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__116(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__141(rest, acc, stack, context, line, offset) do
    authorization_parser__142(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__142(
         <<"signature", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__143(rest, acc, stack, context, comb__line, comb__offset + 9)
  end

  defp authorization_parser__142(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__140(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__143(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__145(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__143(rest, acc, stack, context, line, offset) do
    authorization_parser__144(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__145(rest, acc, stack, context, line, offset) do
    authorization_parser__143(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__144(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__146(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__144(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__140(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__146(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__148(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__146(rest, acc, stack, context, line, offset) do
    authorization_parser__147(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__148(rest, acc, stack, context, line, offset) do
    authorization_parser__146(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__147(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__149(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__149(rest, acc, stack, context, line, offset) do
    authorization_parser__150(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__150(rest, acc, stack, context, line, offset) do
    authorization_parser__160(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__152(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__153(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__152(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__140(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__153(rest, acc, stack, context, line, offset) do
    authorization_parser__155(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__155(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__156(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__155(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__156(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__155(rest, acc, stack, context, line, offset) do
    authorization_parser__154(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__154(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__157(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__156(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__155(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__157(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__158(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__157(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__140(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__158(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__151(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__159(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__152(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__160(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__161(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__160(rest, acc, stack, context, line, offset) do
    authorization_parser__159(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__161(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__163(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__161(rest, acc, stack, context, line, offset) do
    authorization_parser__162(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__163(rest, acc, stack, context, line, offset) do
    authorization_parser__161(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__162(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__151(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__151(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__164(
      rest,
      [signature: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__164(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__15(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__165(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__141(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__166(rest, acc, stack, context, line, offset) do
    authorization_parser__167(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__167(
         <<"keyId", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__168(rest, acc, stack, context, comb__line, comb__offset + 5)
  end

  defp authorization_parser__167(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__165(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__168(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__170(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__168(rest, acc, stack, context, line, offset) do
    authorization_parser__169(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__170(rest, acc, stack, context, line, offset) do
    authorization_parser__168(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__169(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__171(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__169(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__165(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__171(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__173(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__171(rest, acc, stack, context, line, offset) do
    authorization_parser__172(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__173(rest, acc, stack, context, line, offset) do
    authorization_parser__171(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__172(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__174(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__174(rest, acc, stack, context, line, offset) do
    authorization_parser__175(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__175(rest, acc, stack, context, line, offset) do
    authorization_parser__185(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__177(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__178(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__177(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__165(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__178(rest, acc, stack, context, line, offset) do
    authorization_parser__180(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__180(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__181(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__180(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__181(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__180(rest, acc, stack, context, line, offset) do
    authorization_parser__179(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__179(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__182(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__181(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__180(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__182(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__183(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__182(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__165(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__183(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__176(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__184(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__177(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__185(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__186(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__185(rest, acc, stack, context, line, offset) do
    authorization_parser__184(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__186(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__188(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__186(rest, acc, stack, context, line, offset) do
    authorization_parser__187(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__188(rest, acc, stack, context, line, offset) do
    authorization_parser__186(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__187(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__176(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__176(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__189(
      rest,
      [key_id: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__189(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__15(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__15(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__11(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__11(rest, acc, stack, context, line, offset) do
    authorization_parser__191(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__191(rest, acc, stack, context, line, offset) do
    authorization_parser__192(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__192(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__194(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__192(rest, acc, stack, context, line, offset) do
    authorization_parser__193(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__194(rest, acc, stack, context, line, offset) do
    authorization_parser__192(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__193(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 44 do
    authorization_parser__195(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__193(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__190(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__195(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__197(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__195(rest, acc, stack, context, line, offset) do
    authorization_parser__196(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__197(rest, acc, stack, context, line, offset) do
    authorization_parser__195(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__196(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__198(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__198(rest, acc, stack, context, line, offset) do
    authorization_parser__202(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__200(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__199(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__201(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__200(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__202(rest, acc, stack, context, line, offset) do
    authorization_parser__354(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__204(rest, acc, stack, context, line, offset) do
    authorization_parser__205(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__205(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__206(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__205(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__201(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__206(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__208(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__206(rest, acc, stack, context, line, offset) do
    authorization_parser__207(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__208(rest, acc, stack, context, line, offset) do
    authorization_parser__206(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__207(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__210(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__207(rest, acc, stack, context, line, offset) do
    authorization_parser__209(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__210(rest, acc, stack, context, line, offset) do
    authorization_parser__207(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__209(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__211(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__209(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__201(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__211(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__213(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__211(rest, acc, stack, context, line, offset) do
    authorization_parser__212(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__213(rest, acc, stack, context, line, offset) do
    authorization_parser__211(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__212(rest, acc, stack, context, line, offset) do
    authorization_parser__223(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__215(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__216(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__215(rest, _acc, stack, context, line, offset) do
    [_, _, _, _, acc | stack] = stack
    authorization_parser__201(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__216(rest, acc, stack, context, line, offset) do
    authorization_parser__218(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__218(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__219(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__218(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__219(rest, acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__218(rest, acc, stack, context, line, offset) do
    authorization_parser__217(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__217(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__220(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__219(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__218(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__220(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__221(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__220(rest, _acc, stack, context, line, offset) do
    [_, _, _, _, acc | stack] = stack
    authorization_parser__201(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__221(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__214(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__222(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__215(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__223(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__224(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__223(rest, acc, stack, context, line, offset) do
    authorization_parser__222(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__224(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__226(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__224(rest, acc, stack, context, line, offset) do
    authorization_parser__225(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__226(rest, acc, stack, context, line, offset) do
    authorization_parser__224(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__225(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__214(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__214(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__227(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__227(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__203(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__228(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__204(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__229(rest, acc, stack, context, line, offset) do
    authorization_parser__230(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__230(
         <<"headers", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__231(rest, acc, stack, context, comb__line, comb__offset + 7)
  end

  defp authorization_parser__230(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__228(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__231(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__233(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__231(rest, acc, stack, context, line, offset) do
    authorization_parser__232(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__233(rest, acc, stack, context, line, offset) do
    authorization_parser__231(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__232(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__234(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__232(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__228(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__234(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__236(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__234(rest, acc, stack, context, line, offset) do
    authorization_parser__235(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__236(rest, acc, stack, context, line, offset) do
    authorization_parser__234(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__235(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__237(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__237(rest, acc, stack, context, line, offset) do
    authorization_parser__238(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__238(rest, acc, stack, context, line, offset) do
    authorization_parser__248(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__240(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__241(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__240(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__228(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__241(rest, acc, stack, context, line, offset) do
    authorization_parser__243(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__243(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__244(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__243(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__244(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__243(rest, acc, stack, context, line, offset) do
    authorization_parser__242(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__242(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__245(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__244(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__243(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__245(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__246(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__245(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__228(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__246(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__239(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__247(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__240(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__248(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__249(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__248(rest, acc, stack, context, line, offset) do
    authorization_parser__247(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__249(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__251(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__249(rest, acc, stack, context, line, offset) do
    authorization_parser__250(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__251(rest, acc, stack, context, line, offset) do
    authorization_parser__249(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__250(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__239(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__239(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__252(
      rest,
      [headers: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__252(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__203(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__253(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__229(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__254(rest, acc, stack, context, line, offset) do
    authorization_parser__255(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__255(
         <<"expires", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__256(rest, acc, stack, context, comb__line, comb__offset + 7)
  end

  defp authorization_parser__255(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__253(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__256(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__258(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__256(rest, acc, stack, context, line, offset) do
    authorization_parser__257(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__258(rest, acc, stack, context, line, offset) do
    authorization_parser__256(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__257(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__259(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__257(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__253(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__259(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__261(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__259(rest, acc, stack, context, line, offset) do
    authorization_parser__260(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__261(rest, acc, stack, context, line, offset) do
    authorization_parser__259(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__260(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__262(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__262(rest, acc, stack, context, line, offset) do
    authorization_parser__263(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__263(rest, acc, stack, context, line, offset) do
    authorization_parser__273(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__265(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__266(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__265(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__253(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__266(rest, acc, stack, context, line, offset) do
    authorization_parser__268(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__268(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__269(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__268(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__269(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__268(rest, acc, stack, context, line, offset) do
    authorization_parser__267(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__267(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__270(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__269(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__268(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__270(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__271(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__270(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__253(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__271(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__264(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__272(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__265(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__273(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__274(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__273(rest, acc, stack, context, line, offset) do
    authorization_parser__272(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__274(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__276(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__274(rest, acc, stack, context, line, offset) do
    authorization_parser__275(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__276(rest, acc, stack, context, line, offset) do
    authorization_parser__274(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__275(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__264(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__264(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__277(
      rest,
      [expires: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__277(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__203(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__278(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__254(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__279(rest, acc, stack, context, line, offset) do
    authorization_parser__280(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__280(
         <<"created", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__281(rest, acc, stack, context, comb__line, comb__offset + 7)
  end

  defp authorization_parser__280(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__278(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__281(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__283(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__281(rest, acc, stack, context, line, offset) do
    authorization_parser__282(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__283(rest, acc, stack, context, line, offset) do
    authorization_parser__281(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__282(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__284(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__282(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__278(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__284(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__286(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__284(rest, acc, stack, context, line, offset) do
    authorization_parser__285(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__286(rest, acc, stack, context, line, offset) do
    authorization_parser__284(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__285(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__287(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__287(rest, acc, stack, context, line, offset) do
    authorization_parser__288(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__288(rest, acc, stack, context, line, offset) do
    authorization_parser__298(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__290(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__291(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__290(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__278(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__291(rest, acc, stack, context, line, offset) do
    authorization_parser__293(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__293(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__294(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__293(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__294(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__293(rest, acc, stack, context, line, offset) do
    authorization_parser__292(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__292(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__295(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__294(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__293(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__295(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__296(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__295(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__278(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__296(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__289(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__297(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__290(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__298(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__299(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__298(rest, acc, stack, context, line, offset) do
    authorization_parser__297(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__299(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__301(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__299(rest, acc, stack, context, line, offset) do
    authorization_parser__300(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__301(rest, acc, stack, context, line, offset) do
    authorization_parser__299(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__300(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__289(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__289(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__302(
      rest,
      [created: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__302(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__203(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__303(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__279(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__304(rest, acc, stack, context, line, offset) do
    authorization_parser__305(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__305(
         <<"algorithm", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__306(rest, acc, stack, context, comb__line, comb__offset + 9)
  end

  defp authorization_parser__305(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__303(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__306(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__308(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__306(rest, acc, stack, context, line, offset) do
    authorization_parser__307(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__308(rest, acc, stack, context, line, offset) do
    authorization_parser__306(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__307(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__309(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__307(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__303(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__309(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__311(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__309(rest, acc, stack, context, line, offset) do
    authorization_parser__310(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__311(rest, acc, stack, context, line, offset) do
    authorization_parser__309(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__310(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__312(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__312(rest, acc, stack, context, line, offset) do
    authorization_parser__313(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__313(rest, acc, stack, context, line, offset) do
    authorization_parser__323(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__315(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__316(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__315(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__303(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__316(rest, acc, stack, context, line, offset) do
    authorization_parser__318(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__318(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__319(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__318(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__319(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__318(rest, acc, stack, context, line, offset) do
    authorization_parser__317(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__317(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__320(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__319(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__318(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__320(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__321(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__320(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__303(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__321(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__314(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__322(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__315(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__323(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__324(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__323(rest, acc, stack, context, line, offset) do
    authorization_parser__322(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__324(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__326(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__324(rest, acc, stack, context, line, offset) do
    authorization_parser__325(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__326(rest, acc, stack, context, line, offset) do
    authorization_parser__324(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__325(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__314(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__314(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__327(
      rest,
      [algorithm: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__327(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__203(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__328(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__304(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__329(rest, acc, stack, context, line, offset) do
    authorization_parser__330(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__330(
         <<"signature", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__331(rest, acc, stack, context, comb__line, comb__offset + 9)
  end

  defp authorization_parser__330(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__328(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__331(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__333(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__331(rest, acc, stack, context, line, offset) do
    authorization_parser__332(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__333(rest, acc, stack, context, line, offset) do
    authorization_parser__331(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__332(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__334(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__332(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__328(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__334(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__336(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__334(rest, acc, stack, context, line, offset) do
    authorization_parser__335(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__336(rest, acc, stack, context, line, offset) do
    authorization_parser__334(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__335(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__337(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__337(rest, acc, stack, context, line, offset) do
    authorization_parser__338(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__338(rest, acc, stack, context, line, offset) do
    authorization_parser__348(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__340(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__341(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__340(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__328(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__341(rest, acc, stack, context, line, offset) do
    authorization_parser__343(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__343(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__344(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__343(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__344(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__343(rest, acc, stack, context, line, offset) do
    authorization_parser__342(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__342(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__345(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__344(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__343(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__345(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__346(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__345(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__328(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__346(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__339(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__347(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__340(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__348(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__349(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__348(rest, acc, stack, context, line, offset) do
    authorization_parser__347(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__349(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__351(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__349(rest, acc, stack, context, line, offset) do
    authorization_parser__350(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__351(rest, acc, stack, context, line, offset) do
    authorization_parser__349(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__350(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__339(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__339(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__352(
      rest,
      [signature: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__352(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__203(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__353(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__329(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__354(rest, acc, stack, context, line, offset) do
    authorization_parser__355(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__355(
         <<"keyId", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    authorization_parser__356(rest, acc, stack, context, comb__line, comb__offset + 5)
  end

  defp authorization_parser__355(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__353(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__356(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__358(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__356(rest, acc, stack, context, line, offset) do
    authorization_parser__357(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__358(rest, acc, stack, context, line, offset) do
    authorization_parser__356(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__357(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 61 do
    authorization_parser__359(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__357(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    authorization_parser__353(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__359(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 32 or x0 === 9 do
    authorization_parser__361(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__359(rest, acc, stack, context, line, offset) do
    authorization_parser__360(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__361(rest, acc, stack, context, line, offset) do
    authorization_parser__359(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__360(rest, _user_acc, [acc | stack], context, line, offset) do
    authorization_parser__362(rest, [] ++ acc, stack, context, line, offset)
  end

  defp authorization_parser__362(rest, acc, stack, context, line, offset) do
    authorization_parser__363(rest, [], [acc | stack], context, line, offset)
  end

  defp authorization_parser__363(rest, acc, stack, context, line, offset) do
    authorization_parser__373(
      rest,
      [],
      [{rest, context, line, offset}, acc | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__365(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__366(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__365(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__353(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__366(rest, acc, stack, context, line, offset) do
    authorization_parser__368(
      rest,
      [],
      [{rest, acc, context, line, offset} | stack],
      context,
      line,
      offset
    )
  end

  defp authorization_parser__368(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 9 or x0 === 32 or x0 === 33 or (x0 >= 35 and x0 <= 91) or
              (x0 >= 93 and x0 <= 126) or (x0 >= 128 and x0 <= 255) do
    authorization_parser__369(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__368(
         <<x0::integer, x1::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 92 and
              (x1 === 9 or x1 === 32 or (x1 >= 33 and x1 <= 126) or (x1 >= 128 and x1 <= 255)) do
    authorization_parser__369(rest, [x1, x0] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp authorization_parser__368(rest, acc, stack, context, line, offset) do
    authorization_parser__367(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__367(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__370(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__369(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__368(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__370(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 34 do
    authorization_parser__371(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__370(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    authorization_parser__353(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__371(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__364(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__372(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    authorization_parser__365(rest, [], stack, context, line, offset)
  end

  defp authorization_parser__373(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__374(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__373(rest, acc, stack, context, line, offset) do
    authorization_parser__372(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__374(
         <<x0::integer, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 === 33 or x0 === 35 or x0 === 36 or x0 === 37 or x0 === 38 or x0 === 39 or
              x0 === 42 or x0 === 43 or x0 === 45 or x0 === 46 or x0 === 94 or x0 === 95 or
              x0 === 96 or x0 === 124 or x0 === 126 or (x0 >= 48 and x0 <= 57) or
              (x0 >= 97 and x0 <= 122) or (x0 >= 65 and x0 <= 90) do
    authorization_parser__376(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp authorization_parser__374(rest, acc, stack, context, line, offset) do
    authorization_parser__375(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__376(rest, acc, stack, context, line, offset) do
    authorization_parser__374(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__375(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__364(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__364(rest, user_acc, [acc | stack], context, line, offset) do
    authorization_parser__377(
      rest,
      [key_id: :lists.reverse(user_acc)] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp authorization_parser__377(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__203(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__203(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__199(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__190(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    authorization_parser__378(rest, acc, stack, context, line, offset)
  end

  defp authorization_parser__199(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    authorization_parser__191(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp authorization_parser__378(rest, acc, [_, previous_acc | stack], context, line, offset) do
    authorization_parser__2(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp authorization_parser__2(rest, acc, _stack, context, line, offset) do
    {:ok, acc, rest, context, line, offset}
  end

  def authorization(input) do
    with {:ok, result, "", _, _, _} <- authorization_parser(input),
         false <- duplicate_keys?(result) do
      {:ok, Enum.map(result, &unescape/1)}
    else
      _ ->
        {:error, "malformed authorization header"}
    end
  end

  defp duplicate_keys?(keyword_list) do
    keys = Keyword.keys(keyword_list)
    unique_keys = Enum.uniq(keys)
    length(keys) != length(unique_keys)
  end

  defp unescape({key, [?" | rest]}) do
    {key, to_string(unescape_value(rest))}
  end

  defp unescape({key, value}) do
    {key, to_string(value)}
  end

  defp unescape_value(value, acc \\ [])

  defp unescape_value([?"], acc), do: Enum.reverse(acc)

  defp unescape_value([?\\, c | rest], acc) do
    unescape_value(rest, [c | acc])
  end

  defp unescape_value([c | rest], acc) do
    unescape_value(rest, [c | acc])
  end
end
