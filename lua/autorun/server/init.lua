MsgN("Nub's Warnings - Loading...")

if not file.Exists("nubs_warnings", "DATA") then
    file.CreateDir("nubs_warnings")
    file.CreateDir("nubs_warnings/players")
end

AddCSLuaFile("warnings/config.lua")
AddCSLuaFile("warnings/color.lua")
AddCSLuaFile("warnings/cl_vgui.lua")
AddCSLuaFile("warnings/notification.lua")

AddCSLuaFile("warnings/warn/cl_gui.lua")

local clientFiles = file.Find("warnings/warn/menus/client/*.lua", "LUA")
for i, client in pairs(clientFiles) do
    AddCSLuaFile("warnings/warn/menus/client/" .. client)
end

local serverFiles = file.Find("warnings/warn/menus/server/*.lua", "LUA")
for i, server in pairs(serverFiles) do
    include("warnings/warn/menus/server/" .. server)
end

include("warnings/config.lua")
include("warnings/data.lua")
include("warnings/notification.lua")

include("warnings/warn/chat.lua")
include("warnings/warn/permissions.lua")
include("warnings/warn/auth.lua")


-- Send sounds to client
resource.AddFile("sound/nubs_warnings/clickdown.ogg")
resource.AddFile("sound/nubs_warnings/clickup.ogg")
resource.AddFile("sound/nubs_warnings/deepclickdown.ogg")
resource.AddFile("sound/nubs_warnings/deepclickup.ogg")
