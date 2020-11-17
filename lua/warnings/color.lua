-- This file is responsible for addapting colors

function nubs_warnings.shiftColor(color, amount)
    if not IsColor(color) or not isnumber(amount) then return end

    return Color(color.r + amount, color.g + amount, color.b + amount, color.a)
end
function nubs_warnings.alphaColor(color, amount)
    if not IsColor(color) or not isnumber(amount) then return end

    return Color(color.r, color.g, color.b, amount)
end

function nubs_warnings.textColor(color)
    if not IsColor(color) then return end

    -- Determine text color based on luminocity
    if ((color.r * 0.2126) + (color.g * 0.7152) + (color.b * 0.0722)) > 127 then
        return Color(0, 0, 0, color.a)
    end

    return Color(255, 255, 255, color.a)
end
