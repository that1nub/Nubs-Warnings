nubs_warnings.players = nubs_warnings.players or {}

function nubs_warnings.saveData(ply)
    if not isstring(ply) then return end
    if not istable(nubs_warnings.players[ply]) then return end

    file.Write("nubs_warnings/players/" .. ply .. ".json", util.TableToJSON(nubs_warnings.players[ply]))
end

-- hook.Add("Initialize", "NubsWarnings.LoadPlayerData", function()
--     local files = file.Find("nubs_warnings/players/*.json", "DATA")
--     if istable(files) then
--         for i, f in ipairs(files) do
--             local data = util.JSONToTable(file.Read("nubs_warnings/players/" .. f) or "{}")
--         end
--     end
-- end)

-- Get player data
local userfiles,_ = file.Find("nubs_warnings/players/*.json", "DATA")
for _, userfile in pairs(userfiles) do
    local ID = string.sub(userfile, 1, #userfile - 4)
    local data = file.Read("nubs_warnings/players/" .. userfile)
    nubs_warnings.players[ID] = util.JSONToTable(data)
end

-- hook.Add("PlayerInitialSpawn", "NubsWarnings.AddPlayerData", function(ply)
--     if ply:IsBot() then return end
--
--     local data = {}
--     if file.Exists("nubs_warnings/players/" .. ply:SteamID64() .. ".json", "DATA") then
--         data = util.JSONToTable(file.Read("nubs_warnings/players/" .. ply:SteamID64() .. ".json") or "{}")
--     end
--
--     nubs_warnings.players[ply:SteamID64()] = data
-- end)
hook.Add("PlayerInitialSpawn", "NubsWarnings.SetupNewcomer", function(ply)
    if ply:IsBot() then return end

    if not istable(nubs_warnings.players[ply:SteamID64()]) then nubs_warnings.players[ply:SteamID64()] = {} end
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "NubsWarnings.SavePlayerLeftData", function(data)
    if data.bot == 1 then return end

    local id = util.SteamIDTo64(data.networkid)

    if nubs_warnings.players[id] == nil then return end
    local d = nubs_warnings.players[id]

    if not istable(d.names) then d.names = {} end
    if not table.HasValue(d.names, data.name) then
        table.insert(d.names, data.name)
    end

    d.recentName = data.name
    d.steamid = data.networkid

    nubs_warnings.saveData(id)
    nubs_warnings.players[id] = nil
    MsgN("Nub's Warnings: Saved data for disconnected player - " .. data.name)
end)

local lastSaved = 0
hook.Add("Think", "NubsWarnings.AutoSave", function()
    local now = os.time()
    if now - lastSaved >= 30 then
        local saved = 0
        for i, ply in ipairs(player.GetHumans()) do
            if nubs_warnings.players[ply:SteamID64()] == nil then
                nubs_warnings.players[ply:SteamID64()] = {}
            end

            local data = nubs_warnings.players[ply:SteamID64()]

            if not istable(data.names) then data.names = {} end
            if not table.HasValue(data.names, ply:Nick()) then
                table.insert(data.names, ply:Nick())
            end

            data.recentName = ply:Nick()
            data.steamid = ply:SteamID()

            nubs_warnings.saveData(ply:SteamID64())
            saved = saved + 1
        end
        -- if saved > 0 then
        --     MsgN("Nubs Warnings: Saved data for " .. tostring(saved) .. " " .. (saved > 1 and "players" or "player") .. ".")
        -- end

        lastSaved = now
    end
end)
