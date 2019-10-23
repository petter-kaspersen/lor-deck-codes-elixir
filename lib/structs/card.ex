defmodule LorElixir.Card do
    defstruct code: "", count: 0, faction: %LorElixir.Faction{}

    alias LorElixir.Util

    def create_card(set, faction, card, index) do
        set_string = Util.pad_start(Integer.to_string(set), 2, "0")
        real_faction = LorElixir.Faction.get_faction_from_id(faction)
        card_string = Util.pad_start(Integer.to_string(card), 3, "0")

        %LorElixir.Card{code: set_string <> real_faction.short_code <> card_string, count: index, faction: real_faction}
    end
end