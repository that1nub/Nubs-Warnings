-- This needs to be "global" for this file, so it can be accessed when we send packets and the server responds
local section = section or {}

-- Making life easier
local col = nubs_warnings.color
local sc  = nubs_warnings.shiftColor
local tc  = nubs_warnings.textColor

nubs_warnings.RegisterMenu({
    title = "Warnings Search", -- DON'T CHANGE THIS, YOU WILL BREAK SOME FUNCTIONALITY DOING SO (see /warnings/menus/cl_gui.lua line 77)
    sort = 1,
    OnOpen = function(parent, menu)
        menu.close:SetVisible(false)

        local w, h = ScrW() * 0.8, ScrH() * 0.8

        menu:MoveTo(ScrW()/2 - w/2, ScrH()/2 - h/2, 0.2)
        menu:SizeTo(w, h, 0.2, 0, -1, function()
            menu.close:SetPos(menu:GetWide() - menu.close:GetWide(), 0)
            menu.close:SetVisible(true)

            section.warnings = {}
            section.players  = {}
            local warns = section.warnings
            local plys  = section.players

            -- We are going to create all the panels first, then style them afterwards, to keep things neat and make sure we don't get any "undefined" errors
            warns.panel = vgui.Create("Panel", parent)
            plys.panel = vgui.Create("Panel", parent)

            warns.title = vgui.Create("Panel", warns.panel)
            warns.body = vgui.Create("NubsWarnings_ScrollPanel", warns.panel)

            plys.title = vgui.Create("Panel", plys.panel)

            warns.title:Dock(TOP)
            warns.title:SetTall(40)
            warns.title.bg = sc(col.background, 25)
            warns.title.bgDark = sc(col.background, -50)
            function warns.title:Paint(w, h)
                draw.RoundedBox(0, 0, 0, w, h, self.bg)
                draw.RoundedBox(0, 0, h-2, w, 2, self.bgDark)
                draw.RoundedBox(0, w-1, 0, 1, h, self.bgDark)

                draw.SimpleText("Recent Warnings", "NubsWarnings.Large", w/2, (h-2)/2, self.textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            warns.body:Dock(FILL)
            warns.body:DockMargin(0, 0, 1, 0)

            -- Let the server know we (the client) want to know what the recent warnings are
            net.Start("nwarn_request_recent_warnings")
            net.SendToServer()

            -- This was for testing the custom scroll panel
            -- for i = 1, 100 do
            --     local p = vgui.Create("DButton", warns.body)
            --     p:Dock(TOP)
            --     p:SetTall(32)
            -- end

            plys.title:Dock(TOP)
            plys.title:SetTall(warns.title:GetTall())
            plys.title.bg = sc(col.background, 25)
            plys.title.bgDark = sc(col.background, -50)
            function plys.title:Paint(w, h)
                draw.RoundedBox(0, 0, 0, w, h, self.bg)
                draw.RoundedBox(0, 0, h-2, w, 2, self.bgDark)
                draw.RoundedBox(0, 0, 0, 1, h, self.bgDark)
            end

            warns.panel:Dock(LEFT)
            plys.panel:Dock(FILL)

            warns.panel:DockMargin(0, 0, 0, 0)
            plys.panel:DockMargin(0, 0, 0, 0)

            warns.panel:DockPadding(0, 0, 0, 0)
            plys.panel:DockPadding(0, 0, 0, 0)

            warns.panel:SetWide(parent:GetWide() * 0.8)

            parent:InvalidateLayout(true)

            local bgd = sc(col.background, -50)
            local bgl = sc(col.background, -10)
            function warns.panel:Paint(w, h)
                draw.RoundedBox(0, w-1, 0, 1, h, bgd)
            end
            function plys.panel:Paint(w, h)
                draw.RoundedBox(0, 0, 0, w, h, bgl)
                draw.RoundedBox(0, 0, 0, 1, h, bgd)
            end

            -- function plys.panel:Paint(w, h)
            --     draw.RoundedBox(0, 0, 0, w, h, col.background)
            -- end
            -- title:SetZPos(plys.panel:GetZPos() + 1)
        end)
    end
})

-- After we sent a request to the server, the server should have sent information back:
-- 1. A bool whether or not we can view any warnings 
-- 2. A table of recent warnings, only sent if the above bool is true
net.Receive("nwarn_request_recent_warnings", function()
    if istable(section.warnings) and IsValid(section.warnings.body) then
        local can = net.ReadBool() -- Are we even allowed to see the warnings?

        -- Once again, making things easier on us
        local body = section.warnings.body

        if not can then
            -- Display "you don't have access"
            local noaccess = vgui.Create("NubsWarnings_Basic_Button", body)
            noaccess:Dock(TOP)
            noaccess:SetTall(64)
            noaccess:SetText("You were not authorized by the server to view warnings.")
            noaccess:SetFont("NubsWarnings.Regular")
            noaccess:SetEnabled(false)
            noaccess:SetColor(sc(col.background, 25))
        else
            local warns = net.ReadTable()

            if #warns > 0 then 
                -- Display all recent warnings
                table.sort(warns, function(a, b) return a.time > b.time end)
                
                for i = 1, #warns do
                    local wa = warns[i]

                    local warn = vgui.Create("NubsWarnings_Basic_Button", body)
                    warn:Dock(TOP)
                    warn:SetSize(body:GetWide() - 8, 48)
                    warn:SetText("")
                    warn:SetColor(sc(col.background, 10))
                    warn:SetFont("NubsWarnings.Bold")
                    warn.expanded = false
                    warn.date = os.date("%m/%d/%y", wa.time)
                    warn.time = os.date("%H:%M:%S", wa.time)
                    
                    if i ~= #warns then 
                        warn:DockMargin(0, 0, 0, 4)    
                    end
                    
                    local reasonTxt = vgui.Create("DLabel", warn)
                    reasonTxt:SetFont("NubsWarnings.Bold")
                    reasonTxt:SetText("Reason: ")
                    reasonTxt:SizeToContents()
                    reasonTxt:SetTextColor(tc(col.background))
                    reasonTxt:SetPos(4, 74)
                    
                    local reasonEdit = vgui.Create("NubsWarnings_TextEntry", warn)
                    reasonEdit:SetPos(4 + reasonTxt:GetWide(), 73)
                    reasonEdit:SetSize(warn:GetWide() - reasonTxt:GetWide() - 8, 22)
                    reasonEdit:SetFont("NubsWarnings.Bold")
                    reasonEdit:SetPlaceholderText("Reason for warning")
                    reasonEdit:SetText(wa.reason)
                    
                    local del = vgui.Create("NubsWarnings_Button", warn)
                    del:SetText("Delete Warning")
                    del:SetFont("NubsWarnings.Bold")
                    del:SetColor(col.invalid)
                    del:SetSize(warn:GetWide()/2 - 6, 24)
                    del:SetPos(4, 100)
                    -- del:SetPressSounds(2)
                    
                    local upd = vgui.Create("NubsWarnings_Button", warn)
                    upd:SetText("Update Warning")
                    upd:SetFont("NubsWarnings.Bold")
                    upd:SetSize(warn:GetWide()/2 - 6, 24)
                    upd:SetPos(warn:GetWide()/2 + 2, 100)
                    
                    function warn:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, self:GetColor())
    
                        local tw = draw.SimpleText("Issued to: ", self:GetFont(), 4, 4, self:GetTextColor())
                        draw.SimpleText(wa.target.name, self:GetFont(), tw, 4, col.button)
    
                        local tw = draw.SimpleText("Issued by: ", self:GetFont(), 4, 28, self:GetTextColor())
                        draw.SimpleText(wa.by.name, self:GetFont(), tw, 28, col.button)
    
                        if not self.expanded then 
                            draw.RoundedBox(0, w/2, 0, w/2, h, self:GetColor())
                            draw.RoundedBox(0, w/2-2, 0, 2, h, self:GetTextColor())
    
                            local tw = draw.SimpleText("Reason: ", self:GetFont(), w/2 + 4, 4, self:GetTextColor())
                            draw.SimpleText(wa.reason, self:GetFont(), w/2 + tw + 4, 4, col.button)
                            
                            draw.SimpleText("(Click to expand)", self:GetFont(), w-4, h-4, self:GetTextColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
                        end
                    
                        local wid = 4
                        local tw = draw.SimpleText("Issued on: ", self:GetFont(), 4, 50, self:GetTextColor())
                        wid = wid + tw
    
                        local tw = draw.SimpleText(self.date .. " ", self:GetFont(), wid, 50, col.button)
                        wid = wid + tw
    
                        local tw = draw.SimpleText("@ ", self:GetFont(), wid, 50, self:GetTextColor())
                        wid = wid + tw
    
                        draw.SimpleText(self.time, self:GetFont(), wid, 50, col.button)

                        reasonEdit:SetWide(self:GetWide() - reasonTxt:GetWide() - 8)
                        del:SetWide(self:GetWide() / 2 - 6)
                        upd:SetWide(self:GetWide() / 2 - 6)

                        upd:SetPos(self:GetWide()/2 + 2, 100)
                    end
                    function warn:DoClick()
                        self.expanded = not self.expanded
                        if self.expanded then 
                            self:SizeTo(-1, 128, 0.2)
                        else 
                            self:SizeTo(-1, 48, 0.2)
                        end
                    end
                end
            else 
                -- Display "no recent warnings"
                local nopeeps = vgui.Create("NubsWarnings_Basic_Button", body)
                nopeeps:Dock(TOP)
                nopeeps:SetTall(64)
                nopeeps:SetText("No recent warnings given to anybody.")
                nopeeps:SetFont("NubsWarnings.ExtraLarge")
                nopeeps:SetEnabled(false)
                nopeeps:SetColor(sc(col.background, 25))
            end
        end
    end
end)
