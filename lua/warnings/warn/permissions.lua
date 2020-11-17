if SERVER then
    if ULib ~= nil then
        ULib.ucl.registerAccess("nwarn_warn", {"admin", "superadmin"}, "Give players a warning. Also given access to staff statistics. Can't be warned if they can warn others.", "Nub's Warnings")
        ULib.ucl.registerAccess("nwarn_view", {"admin", "superadmin"}, "View a player's warnings, online or offline.", "Nub's Warnings")
        ULib.ucl.registerAccess("nwarn_delete", {"superadmin"}, "Delete a player's warnings.", "Nub's Warnings")
        ULib.ucl.registerAccess("nwarn_manage", {"superadmin"}, "Manage warning/reporting settings.", "Nub's Warnings")
    end

    nubs_warnings.recentWarnings = nubs_warnings.recentWarnings or {}
    nubs_warnings.recentWarnings[1] = {
        time = os.time(),
        reason = "Testing",
        active = true,
        by = {
            name = "Nub",
            steamid = "STEAM_0:0:91201031",
            steamid64 = "76561198142667790"
        },
        target = {
            name = "Yeet",
            steamid = "STEAM_0:0:0",
            steamid64 = "11565461233579126"
        }
    }
    nubs_warnings.recentWarnings[2] = nubs_warnings.recentWarnings[1]
    nubs_warnings.recentWarnings[3] = nubs_warnings.recentWarnings[1]
    nubs_warnings.recentWarnings[4] = nubs_warnings.recentWarnings[1]
    nubs_warnings.recentWarnings[5] = nubs_warnings.recentWarnings[1]
    nubs_warnings.recentWarnings[6] = nubs_warnings.recentWarnings[1]
    nubs_warnings.recentWarnings[7] = nubs_warnings.recentWarnings[1]
    nubs_warnings.recentWarnings[8] = nubs_warnings.recentWarnings[1]
    nubs_warnings.recentWarnings[9] = nubs_warnings.recentWarnings[1]
    nubs_warnings.recentWarnings[10] = nubs_warnings.recentWarnings[1]

    function nubs_warnings.warnPlayer(warned, warner, reason)
        if not (isentity(warned) and warned:IsPlayer()) then return end
        if not (isentity(warner) and warner:IsPlayer()) then return end
        if not isstring(reason) then return end

        local warn = {
            time = os.time(),
            reason = reason,
            active = true,
            by = {
                name = warner:Nick(),
                steamid = warner:SteamID(),
                steamid64 = warner:SteamID64()
            },
            target = {
                name = warned:Nick(),
                steamid = warned:SteamID(),
                steamid64 = warned:SteamID64()
            }
        }

        local data = nubs_warnings.players[warned:SteamID64()]
        if not istable(data.warnings) then data.warnings = {} end
        table.insert(data.warnings, table.Copy(warn))

        table.insert(nubs_warnings.recentWarnings, warn)
    end
end

function nubs_warnings.findPlayer(needle, nosteamid)
    local found = {}
    if not isstring(needle) then return found end

    local search = string.lower(needle)
    local searchID
    if not nosteamid then
        searchID = string.upper(needle)
    end

    for i, ply in ipairs(player.GetHumans()) do
        -- if ULib ~= nil then
        --     if ULib.ucl.query(ply, "nwarn_warn") then continue end
        -- else
        --     if ply:IsAdmin() then continue end
        -- end

        if string.find(string.lower(ply:Nick()), search) then
            table.insert(found, ply)
        elseif not nosteamid and string.find(ply:SteamID(), searchID) then
            table.insert(found, ply)
        end
    end

    return found
end

function nubs_warnings.canWarn(ply)
    if not isentity(ply) then return false end
    if not ply:IsPlayer() then return false end

    if ULib ~= nil then -- ULX permission integration
        return ULib.ucl.query(ply, "nwarn_warn")
    end

    return ply:IsAdmin()
end

function nubs_warnings.canView(ply)
    if not isentity(ply) then return false end
    if not ply:IsPlayer() then return false end

    if ULib ~= nil then -- ULX permission integration
        return ULib.ucl.query(ply, "nwarn_view")
    end

    return ply:IsAdmin()
end

function nubs_warnings.canDelete(ply)
    if not isentity(ply) then return false end
    if not ply:IsPlayer() then return false end

    if ULib ~= nil then  -- ULX permission integration
        return ULib.ucl.query(ply, "nwarn_delete")
    end

    return ply:IsSuperAdmin()
end

function nubs_warnings.canManage(ply)
    if not isentity(ply) then return false end
    if not ply:IsPlayer() then return false end

    if ULib ~= nil then -- ULX permission integration
        return ULib.ucl.query(ply, "nwarn_manage")
    end

    return ply:IsSuperAdmin()
end
