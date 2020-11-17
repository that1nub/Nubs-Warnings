-- This file is responsible for the main variables. Don't mess with these,
-- you could break the mod.
nubs_warnings       = nubs_warnings       or {}
nubs_warnings.color = nubs_warnings.color or {}
nubs_warnings.info  = nubs_warnings.info  or {}
nubs_warnings.staff = nubs_warnings.staff or {}

-- Here is what you can edit --

nubs_warnings.info.title = "Nub's Warnings"


-- The color you will see most on the GUI. This is also the color of certain buttons. Default: Color(100, 100, 100)
nubs_warnings.color.background = Color(100, 100, 100)

-- The color of buttons. Default: Color(0, 150, 255)
nubs_warnings.color.button = Color(0, 150, 255)

-- The color of "something went wrong" or a super dangerous button. Default: Color(255, 62, 62)
nubs_warnings.color.invalid = Color(255, 62, 62)

-- Seconds to mark a warning inactive (no longer penalizing). Default: 604800 (1 week)
nubs_warnings.timeToMarkInactive = 604800
