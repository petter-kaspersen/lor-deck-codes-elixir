# Legends of Runeterra Deck Codes - Elixir

This is a port of [LoRDeckCodes](https://github.com/RiotGames/LoRDeckCodes) written in Elixir.

## Usage

Currently, only `LorElixir.decode/1` works.

```elixir
LorElixir.decode("CEAAECABAQJRWHBIFU2DOOYIAEBAMCIMCINCILJZAICACBANE4VCYBABAILR2HRL")
 # => [%LorElixir.Card{code: "", count: 0, faction: %LorElixir.Faction{id: 0, name: "", short_code: ""}}]
```