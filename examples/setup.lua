local rockspec = "liblua-0.1.0-1.rockspec"

local function lookupIfExists(t, key)
    if t == nil then
        return nil
    end
    return t[key]
end

local function moveTable(dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end
local function copyTable(t)
    return moveTable({}, t)
end

local oldGlobals = copyTable(_G)
dofile(rockspec)
local modules = lookupIfExists(build, "modules")
moveTable(_G, oldGlobals)

if modules then
    for modname, filename in pairs(modules) do
        local loader = function() return dofile(filename) end
        package.preload[modname] = loader
    end
end
