nubs_warnings.gui = nubs_warnings.gui or {}

local background = nubs_warnings.color.background -- Makes life easier, avoiding repetative calls
local bg = {
    base = background,
    light = nubs_warnings.shiftColor(background, 25),
    dark = nubs_warnings.shiftColor(background, -25),
    text = nubs_warnings.textColor(background)
}

nubs_warnings.menus = nubs_warnings.menus or {}

local function blankFunc()
end

net.Receive("nwarn_open", function()
    nubs_warnings.OpenGUI(net.ReadEntity())
end)

function nubs_warnings.RegisterMenu(menu)
    local newmenu = menu
    newmenu.title = (isstring(menu.title) and menu.title or "Undefined")
    newmenu.sort = (isnumber(menu.sort) and menu.sort or 0)
    newmenu.OnOpen = (isfunction(menu.OnOpen) and menu.OnOpen or blankFunc)

    if isbool(menu.visible) then
        newmenu.visible = menu.visible
    else
        newmenu.visible = true
    end

    nubs_warnings.menus[newmenu.title] = table.Copy(newmenu)
end

function nubs_warnings.RemoveMenuButtons()
    local menus = nubs_warnings.gui.menus -- Makes life easier

    if istable(menus) and table.IsSequential(menus) then
        for i, menu in ipairs(menus) do
            if IsValid(menu) and isfunction(menu.Remove) then
                menu:Remove()
            end
        end
    end
end

function nubs_warnings.OpenGUI(ply)
    local info = nubs_warnings.info
    local gui  = nubs_warnings.gui -- Makes life easier

    gui.panel = vgui.Create("DFrame")
    gui.panel:SetSize(ScrW()/3, 0)
    gui.panel:SetPos(ScrW()/2 - gui.panel:GetWide()/2, 4)
    gui.panel:SetTitle("")
    gui.panel:ShowCloseButton(false)
    gui.panel:SetDraggable(false)
    gui.panel:SetSizable(false)
    gui.panel.menu = "Dashboard"
    function gui.panel:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, bg.base)
        draw.RoundedBox(0, 0, 0, w, 24, bg.light)
        draw.RoundedBox(0, 0, 24, w, 2, bg.dark)
        draw.SimpleText(info.title .. " - " .. self.menu, "NubsWarnings.Regular", 4, 12, bg.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    gui.panel.close = vgui.Create("NubsWarnings_Button", gui.panel)
    gui.panel.close:SetSize(32, 24)
    gui.panel.close:SetPos(gui.panel:GetWide()-gui.panel.close:GetWide(), 0)
    gui.panel.close:SetText("X")
    function gui.panel.close:DoClick()
        gui.panel:SizeTo(-1, 0, 0.2, 0, -1, function() gui.panel:Remove() end)
    end

    if isentity(ply) and ply:IsPlayer() then
        gui.panel:Center()

        local menu = nubs_warnings.menus["Warnings Search"]
        if istable(menu) then
            gui.panel:DockPadding(4, 30, 4, 4)

            gui.content = vgui.Create("DPanel", gui.panel)
            gui.content:Dock(FILL)
            function gui.content:Paint(w, h)
                draw.RoundedBox(0, 0, 0, w, h, bg.dark)
            end

            if isfunction(menu.OnOpen) then menu.OnOpen(gui.content, gui.panel) end
        end
    else
        gui.panel:DockPadding(4, 26, 4, 4)

        gui.menus = {}

        local menus = {}

        for i, menu in pairs(nubs_warnings.menus) do
            table.insert(menus, menu)
        end

        table.sort(menus, function(a, b) return a.sort < b.sort end)

        for i, menu in ipairs(menus) do
            if not menu.visible then continue end

            local tab = vgui.Create("NubsWarnings_Button", gui.panel)
            tab:Dock(TOP)
            tab:DockMargin(0, 4, 0, 0)
            tab:SetTall(32)
            tab:SetColor(bg.light)
            tab:SetText(menu.title)

            function tab:DoClick()
                gui.panel.menu = menu.title

                nubs_warnings.RemoveMenuButtons()

                gui.panel:DockPadding(4, 30, 4, 4)

                gui.content = vgui.Create("DPanel", gui.panel)
                gui.content:Dock(FILL)
                function gui.content:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, bg.dark)
                end

                if isfunction(menu.OnOpen) then menu.OnOpen(gui.content, gui.panel) end
            end

            table.insert(gui.menus, tab)
        end

        gui.panel:InvalidateLayout(true)
        gui.panel:SizeToChildren(false, true)

        local h = gui.panel:GetTall()
        gui.panel:SetTall(0)

        gui.panel:SizeTo(-1, h, 0.2)
        gui.panel:MakePopup()
    end

end
