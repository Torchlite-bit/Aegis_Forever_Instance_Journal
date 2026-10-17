-- Every English area name the journal uses (ns.AreaNamesUsed, Core/Areas.lua), one "AREA <name>"
-- line each, for Tools/bake_area_ids.py.
local ns = ...
local lines = {}
for _, name in ipairs(ns.AreaNamesUsed()) do lines[#lines + 1] = "AREA " .. name end
return table.concat(lines, "\n")
