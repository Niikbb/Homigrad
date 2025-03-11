-- Convars are here for dedicated servers... (who cares that they are replicated :shrug:)

CreateConVar("hg_LootAlive", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Toggles ability to loot alive players that are faking.", 0, 1)
CreateConVar("hg_SearchTime", "2", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Items in a player's inventory will appear after a given time.", 0, 10)