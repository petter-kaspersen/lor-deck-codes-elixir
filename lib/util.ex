defmodule LorElixir.Util do
    def decode_byte(byte) when is_binary(byte) do
        :binary.decode_unsigned(byte)
    end
    def decode_byte(_byte), do: false

    def remove_first(bytes) when is_binary(bytes) do
        initial_length = byte_size(bytes)

        first_byte = binary_part(bytes, 0, 1)
        rest_bytes = binary_part(bytes, 1, initial_length - 1)

        %{first_byte: first_byte, rest_bytes: rest_bytes}
    end
    def remove_first(_bytes), do: false

    def get_index_in_binary(bytes, index) do
        bytes
         |> :binary.bin_to_list
         |> Enum.at(index)
    end

    def pad_start(item, length, padding) do
        string_length = String.length(item)

        if string_length >= length do
            item
        else
            pad_start(padding <> item, length, padding)
        end
    end


end