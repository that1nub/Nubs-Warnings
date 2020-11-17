-- Following definitions make this file easier to add to
local col = nubs_warnings.color
local sc  = nubs_warnings.shiftColor
local ac  = nubs_warnings.alphaColor
local tc  = nubs_warnings.textColor

-- NubsWarnings_Button
local PANEL = {}

function PANEL:Init()
    self.text = "Button"
    self.font = "NubsWarnings.Regular"

    self.color = {}
    self.color.normal  = col.button
    self.color.hovered = sc(self.color.normal, 25)
    self.color.down    = sc(self.color.normal, 10)
    self.color.text    = tc(self.color.normal)
    self.color.shadow  = sc(self.color.normal, -50)

    self.buttonSounds = {
        {"nubs_warnings/clickdown.ogg", "nubs_warnings/clickup.ogg"},
        {"nubs_warnings/deepclickdown.ogg", "nubs_warnings/deepclickup.ogg"}
    }
    self.selectedSound = 1

    self:SetText("")

    -- These functions are inside to allow the SetText function above work without conflicts
    function self:SetText(text)
        if not isstring(text) then return end

        self.text = text
    end
    function self:GetText()
        return self.text
    end
    function self:SetFont(font)
        if not isstring(font) then return end
        self.font = font
    end
    function self:GetFont()
        return self.font
    end

    function self:SetColor(color, noText)
        if not IsColor(color) then return end

        self.color.normal  = color
        self.color.hovered = sc(self.color.normal, 25)
        self.color.down    = sc(self.color.normal, 10)
        self.color.shadow  = sc(self.color.normal, -50)

        if not noText then
            self.color.text = tc(self.color.normal)
        end
    end
    function self:GetColor()
        return self.color.normal
    end

    function self:SetTextColor(color)
        if not IsColor(color) then return end

        self.color.text = color
    end
    function self:GetTextColor()
        return self.color.text
    end

    function self:GetPressSounds()
        if isnumber(self.selectedSound) then
            return self.buttonSounds[self.selectedSound]
        end
    end

    function self:SetPressSounds(ind)
        if not isnumber(ind) then return end

        self.selectedSound = ind
    end

    function self:PlayDown()
        local sounds = self:GetPressSounds()
        if istable(sounds) and isstring(sounds[1]) then
            surface.PlaySound(sounds[1])
        end
    end

    function self:PlayUp()
        local sounds = self:GetPressSounds()
        if istable(sounds) and isstring(sounds[2]) then
            surface.PlaySound(sounds[2])
        end
    end

    function self:OnDepressed()
        self:PlayDown()
    end
    function self:OnReleased()
        self:PlayUp()
    end

    function self:Paint(w, h)
        local offset = (self:IsEnabled() and (self:IsDown() and 2 or 0)) or 0

        local color = self:GetColor()
        local tc = self:GetTextColor()

        if self:IsEnabled() then
            if self:IsDown() then
                color = self.color.down
            elseif self:IsHovered() then
                color = self.color.hovered
            end
        else 
            color = sc(color, -15)
        end

        draw.RoundedBox(0, 0, offset, w, h, color)

        if self:IsEnabled() and not self:IsDown() then
            draw.RoundedBox(0, 0, h-2, w, 2, self.color.shadow)
        end

        draw.SimpleText(self:GetText(), "NubsWarnings.Bold", w/2, h/2 + offset - 1, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("NubsWarnings_Button", PANEL, "DButton")


-- NubsWarnings_Basic_Button
local PANEL = {}

function PANEL:Init()
    self.text = "Button"
    self.font = "NubsWarnings.Regular"

    self.color = {}
    self.color.normal  = col.button
    self.color.hovered = sc(self.color.normal, 25)
    self.color.down    = sc(self.color.normal, 10)
    self.color.text    = tc(self.color.normal)

    self:SetText("")

    -- These functions are inside to allow the SetText function above work without conflicts
    function self:SetText(text)
        if not isstring(text) then return end

        self.text = text
    end
    function self:GetText()
        return self.text
    end
    function self:SetFont(font)
        if not isstring(font) then return end
        self.font = font
    end
    function self:GetFont()
        return self.font
    end

    function self:SetColor(color, noText)
        if not IsColor(color) then return end

        self.color.normal  = color
        self.color.hovered = sc(self.color.normal, 25)
        self.color.down    = sc(self.color.normal, 10)
        self.color.shadow  = sc(self.color.normal, -50)

        if not noText then
            self.color.text = tc(self.color.normal)
        end
    end
    function self:GetColor()
        return self.color.normal
    end

    function self:SetTextColor(color)
        if not IsColor(color) then return end

        self.color.text = color
    end
    function self:GetTextColor()
        return self.color.text
    end

    function self:Paint(w, h)

        local color = self:GetColor()
        local tc = self:GetTextColor()

        if self:IsEnabled() then 
            if self:IsDown() then
                color = self.color.down
            elseif self:IsHovered() then
                color = self.color.hovered
            end
        else 
            color = sc(color, -15)
        end

        draw.RoundedBox(0, 0, 0, w, h, color)

        draw.SimpleText(self:GetText(), "NubsWarnings.Bold", w/2, h/2, tc, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("NubsWarnings_Basic_Button", PANEL, "DButton")


-- NubsWarnings_TextEntry
local PANEL = {}

function PANEL:Init()
    self.color = sc(col.background, -25)
    self:SetTextColor(tc(self.color))
    self.errorColor = col.invalid
    self.errored = false

    self:SetFont("NubsWarnings.Regular")

    function self:SetColor(col, no_update)
        if not IsColor(col) then return end

        self.color = col
        if not no_update then
            self:SetTextColor(tc(col))
        end
    end
    function self:GetColor() return self.color end

    function self:SetErrorColor(col)
        if not IsColor(col) then return end

        self.errorColor = col
    end
    function self:GetErrorColor() return self.errorColor end

    function self:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, self:GetColor())

        if self.errored then
            draw.RoundedBox(0, 0, 0, w, h, ac(self.errorColor, 50))
        end

        local textColor = self:GetTextColor()
        if self:GetText() == "" then
            draw.SimpleText(self:GetPlaceholderText(), self:GetFont(), 2, h/2, ac(textColor, 75), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        self:DrawTextEntryText(textColor, col.button, textColor)
    end
end

vgui.Register("NubsWarnings_TextEntry", PANEL, "DTextEntry")


-- NubsWarnings_ScrollPanel
local PANEL = {}

function PANEL:Init()
    self.color = col.background

    function self:SetColor(col)
        if not IsColor(col) then return end

        self.color = col
    end
    function self:GetColor() return self.color end

    self:GetCanvas():DockPadding(4, 4, 4, 4)

    local vbar = self:GetVBar()
    if IsValid(vbar) then
        vbar:SetWide(8)
        local col = self:GetColor()
        function vbar.btnGrip:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, col)
        end
        function vbar:Paint() end

        function vbar.btnUp:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, col)
            draw.RoundedBox(0, 0, h-2, w, 2, sc(col, -50))
        end
        function vbar.btnDown:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, col)
            draw.RoundedBox(0, 0, 0, w, 2, sc(col, -50))
        end
    end
end

vgui.Register("NubsWarnings_ScrollPanel", PANEL, "DScrollPanel")
