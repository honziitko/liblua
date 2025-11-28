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
    if not package.loaded then
        package.loaded = {}
    end
    for libname, filename in pairs(modules) do
        package.loaded[libname] = dofile(filename)
    end
end
