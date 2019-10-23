defmodule LorElixir.Faction do
    defstruct id: -1, short_code: "", name: ""

    alias LorElixir.Faction

    def get_faction_from_id(id) do
        factions = [
            %Faction{
                id: 0,
                short_code: "DE",
                name: "Demacia"
            },
            %Faction{
                id: 1,
                short_code: "FR",
                name: "Freljord"
            },
            %Faction{
                id: 2,
                short_code: "IO",
                name: "Ionia"
            },
            %Faction{
                id: 3,
                short_code: "NX",
                name: "Noxus"
            },
            %Faction{
                id: 4,
                short_code: "PZ",
                name: "Piltover & Zaun"
            },
            %Faction{
                id: 5,
                short_code: "SI",
                name: "Shadow Isles"
            }
        ]

        Enum.find(factions, fn x -> x.id == id end)
    end
end
