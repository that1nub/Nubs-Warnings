MsgN("Nub's Warnings - Loading...")

surface.CreateFont("NubsWarnings.Regular", {
    size = 20
})
surface.CreateFont("NubsWarnings.Bold", {
    size = 20,
    weight = 800
})

surface.CreateFont("NubsWarnings.Large", {
    size = 28
})

surface.CreateFont("NubsWarnings.ExtraLarge", {
    size = 36
})

include("warnings/config.lua")
include("warnings/color.lua")
include("warnings/cl_vgui.lua")
include("warnings/notification.lua")

include("warnings/warn/cl_gui.lua")

local clientFiles = file.Find("warnings/warn/menus/client/*.lua", "LUA")
for i, client in pairs(clientFiles) do
    include("warnings/warn/menus/client/" .. client)
end
