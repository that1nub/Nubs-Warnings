-- This file is responsible for authorizing data to be sent to a client
util.AddNetworkString("nwarn_request_recent_warnings")

net.Receive("nwarn_request_recent_warnings", function(len, ply)
    net.Start("nwarn_request_recent_warnings")
    if nubs_warnings.canView(ply) then
        net.WriteBool(true)
        net.WriteTable(table.Copy(nubs_warnings.recentWarnings))
    else
        net.WriteBool(false)
    end
    net.Send(ply)
end)
