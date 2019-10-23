defmodule LorElixir.VarInt do
    use Bitwise

    alias LorElixir.Util

    @param %{result: 0, popped_bytes: 0, done: false, rest_bytes: 0, current_shift: 0}

    def pop(bytes) when is_binary(bytes) do
        bytes_length = byte_size(bytes)

        Enum.reduce(0..bytes_length - 1, @param, fn curr, acc ->
            if acc.done do
                acc
            else
                new_bytes_popped = acc.popped_bytes + 1
                current_element = element_at_index(bytes, curr)
    
                current = band(current_element, 0x7f)
                result = bor(acc.result, bsl(current, acc.current_shift))
                new_shift = acc.current_shift + 7

                to_return = %{acc |
                      result: result, current_shift: new_shift,
                      popped_bytes: new_bytes_popped}

                if band(current_element, 0x80) !== 0x80 do
                    rest_bytes = binary_part(bytes, new_bytes_popped, bytes_length - 1)
                    %{to_return | done: true, rest_bytes: rest_bytes}
                else
                    to_return
                end
            end
        end)
    end
    
    defp element_at_index(bytes, index) do
        bytes
         |> :binary.bin_to_list
         |> Enum.at(index)
    end
end