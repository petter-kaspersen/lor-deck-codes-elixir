defmodule LorElixir do
  use Bitwise

  alias LorElixir.Util
  alias LorElixir.VarInt

  def decode(code) when is_binary(code) do
    case Base.decode32(code) do
      {:ok, results} ->
        case is_valid_version(results) do
          {:ok, bytes: bytes} ->
            get_cards(bytes)
          {:error, error} ->
            raise error
        end
      :error ->
        raise "Invalid Base32 string"
    end
  end
  def decode(_code), do: raise "Invalid deck code"

  defp is_valid_version(bytes) when is_binary(bytes) do
    %{first_byte: first_byte, rest_bytes: rest_bytes} = Util.remove_first(bytes)

    version =
      first_byte
       |> Util.decode_byte
       |> Bitwise.band(0xF)

    if version <= 1 do
      {:ok, bytes: rest_bytes}
    else
      {:error, "Unsupported version. Deck is version #{version}. Expected 1."}
    end
  end
  defp is_valid_version(_bytes), do: {:error, "Something went wrong decoding the deck."}

  defp get_cards(bytes) when is_binary(bytes) do
      %{cards: three_cards, rest_bytes: rest_bytes} = extract_cards(bytes, 3)
      %{cards: two_cards, rest_bytes: rest_bytes} = extract_cards(rest_bytes, 2)
      %{cards: one_cards, rest_bytes: _bytes} = extract_cards(rest_bytes, 1)

      three_cards ++ two_cards ++ one_cards
  end

  defp extract_cards(bytes, amount) when is_binary(bytes) do
    %{result: to_get, rest_bytes: rest_bytes} = VarInt.pop(bytes)


    if to_get == 0 do
      %{cards: [], rest_bytes: rest_bytes}
    else
      Enum.reduce(0..to_get - 1, %{cards: [], rest_bytes: rest_bytes}, fn _curr, acc ->
        %{result: cards_in_faction, rest_bytes: rest_bytes} = VarInt.pop(acc.rest_bytes)
        %{result: set, rest_bytes: rest_bytes} = VarInt.pop(rest_bytes)
        %{result: faction, rest_bytes: rest_bytes} = VarInt.pop(rest_bytes)

        %{cards: cards, bytes: rest_bytes} = Enum.reduce(0..cards_in_faction - 1, %{cards: [], bytes: rest_bytes}, fn _card_curr, card_acc ->
          %{result: this_card, rest_bytes: rest_bytes} = VarInt.pop(card_acc.bytes)

          created_card = LorElixir.Card.create_card(set, faction, this_card, amount)
          %{cards: card_acc.cards ++ [created_card], bytes: rest_bytes}
        end)

        %{acc | rest_bytes: rest_bytes, cards: acc.cards ++ cards}
      end)
    end
  end
end
