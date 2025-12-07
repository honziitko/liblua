---@module "liblua.internal.preproc"
local M = {}

local utils = require("liblua.utils")

local FILENAME = {
    SELF = 1,
    CALLER = 2,
    STDHEADER = 4,
}

---@type table<string, table<string, string>>
local definitions = {}
---@type string[]
local callStack = {}

function M.callerFilename(n)
    n = n or 1
    local i = utils.STACK_SELF
    local lastFilename = nil
    local filename
    repeat
        local info = debug.getinfo(i, "S")
        assert(info, "Preprocessor must be called from a file")
        local source = info.source
        filename = source:match("^@(.*)$")
        if filename then
            if filename ~= lastFilename then
                lastFilename = filename
                n = n - 1
            end
        end
        i = i + 1
    until n == 0
    return filename
end

local function gsubEscape(s)
    -- gsub returns two values
    local temp = s:gsub("(%W)", "%%%1")
    return temp
end

local function preprocess(source, filename)
    local defs = definitions[filename]
    if not defs then
        return source
    end
    local out = source
    local wordBoundary = "[^_%w]"
    for rawName, rawValue in pairs(defs) do
        local name = gsubEscape(rawName)
        local value = gsubEscape(rawValue)
        local pattern = string.format("(%s)%s(%s)", wordBoundary, name, wordBoundary)
        out = out:gsub(pattern, "%1" .. value .. "%2")
    end
    return out
end

function M.preprocessed()
    local callerFilename = M.callerFilename(FILENAME.CALLER)
    local topFilename = callStack[#callStack]
    if topFilename and callerFilename == topFilename then
        -- Executing preprocessor output
        return false
    end
    -- Not precprocessed; execute preprocessor
    return true
end

function M.returnValue()
    local filename = M.callerFilename(FILENAME.CALLER)
    table.insert(callStack, filename)
    local file = assert(io.open(filename, "r"))
    local source = file:read("*a")
    file:close()
    local func = assert(loadstring(preprocess(source, filename), "@" .. filename))
    local returnVal = func()
    table.remove(callStack)
    return returnVal
end

function M.stdlibDefine(name, value)
    local filename = M.callerFilename(FILENAME.STDHEADER)
    if not definitions[filename] then
        definitions[filename] = {}
    end
    definitions[filename][name] = value
end

return M
