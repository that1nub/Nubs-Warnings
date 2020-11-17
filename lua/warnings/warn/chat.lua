util.AddNetworkString("nwarn_open")

hook.Add("PlayerSay", "nwarn_commands", function(caller, message, teamChat)
    local args = string.Explode(" +", message, true)
    local cmd = string.lower(table.remove(args, 1))

    local numArgs = #args

    -- if cmd == "!warn" or cmd == "!warns" or cmd == "!warnings" then
    if cmd == "!w" then
        if numArgs == 0 then
            if nubs_warnings.canView(caller) then
                caller:SendLua("nubs_warnings.OpenGUI()")
            else
                nubs_warnings.notify(caller, Color(255, 62, 62), "You don't have permssion to view the warnings menu.")
            end
        elseif numArgs == 1 then
            if nubs_warnings.canView(caller) then
                local ply = nubs_warnings.findPlayer(args[1])
                local numPly = #ply

                if numPly == 1 then
                    net.Start("nwarn_open")
                        net.WriteEntity(ply[1])
                    net.Send(caller)
                elseif numPly > 1 then
                    nubs_warnings.notify(caller, Color(255, 62, 62), "Too many players found. Please be more specific.")
                else
                    nubs_warnings.notify(caller, Color(255, 62, 62), "No players were found. Please be less specific. Maybe who you are targetting can't be warned.")
                end
            else
                nubs_warnings.notify(caller, Color(255, 62, 62), "You don't have permssion to view the warnings menu.")
            end
        else
            if nubs_warnings.canWarn(caller) then
                local targs = nubs_warnings.findPlayer(table.remove(args, 1))
                local numTargs = #targs

                if numTargs == 1 then
                    local reason = table.concat(args, " ")

                    nubs_warnings.warnPlayer(targs[1], caller, reason)

                    nubs_warnings.notify(Color(98, 176, 255), targs[1]:Nick(), Color(255, 255, 255), " has been warned for ", Color(255, 62, 62), reason)
                elseif numTargs > 1 then
                    nubs_warnings.notify(caller, Color(255, 62, 62), "Too many players found. Please be more specific.")
                else
                    nubs_warnings.notify(caller, Color(255, 62, 62), "No players were found. Please be less specific. Maybe who you are targetting can't be warned.")
                end
            else
                nubs_warnings.notify(caller, Color(255, 62, 62), "You don't have permission to warn players.")
            end
        end
    end
end)
