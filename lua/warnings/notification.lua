if SERVER then
    util.AddNetworkString("nwarn_notification")

    -- This function is copied from Evolve, then modified slightly
    -- https://github.com/Xandaros/evolve/blob/master/lua/ev_framework.lua#L69-L118
    function nubs_warnings.notify(...)
        local ply -- Who we send the print to
        local arg = {...} -- All the arguments passed into the function

        -- If the first argument is a player or an invalid entity then the player is that thing
        if type(arg[1]) == "Player" or arg[1] == NULL then ply = arg[1] end
        if ply != NULL then -- Are they a player?
            net.Start("nwarn_notification")
            net.WriteUInt(#arg, 16)
            for _, a in ipairs(arg) do
                if isstring(a) then
                    net.WriteBit(false)
                    net.WriteString(a)
                elseif istable(a) then
                    net.WriteBit(true)
                    net.WriteUInt(a.r, 8)
                    net.WriteUInt(a.g, 8)
                    net.WriteUInt(a.b, 8)
                    net.WriteUInt(a.a, 8)
                elseif isnumber(a) then
                    net.WriteBit(false)
                    net.WriteString(tostring(a))
                end
            end
            if ply ~= nil then --Is the player valid?
                net.Send(ply)
            else
                net.Broadcast()
            end
        end
    end
else
    function nubs_warnings.notify(...) --CLIENT version
        local arg = {...}

        local args = {Color(255, 255, 255), "[", Color(98, 176, 255), "nwarn", Color(255, 255, 255), "] "}
        for _, a in ipairs(arg) do
            if isstring(a) or istable(a) then table.insert(args, a)
            elseif tostring(a) then table.insert(args, a) end
        end

        chat.AddText(unpack(args))
    end

    net.Receive("nwarn_notification", function(len)
        local argc = net.ReadUInt(16)
        local args = {Color(255, 255, 255), "[", Color(98, 176, 255), "nwarn", Color(255, 255, 255), "] "}
        for i = 1, argc do
            if net.ReadBit() == 1 then
                table.insert(args, Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)))
            else
                table.insert(args, net.ReadString())
            end
        end

        chat.AddText(unpack(args))
    end)
end
