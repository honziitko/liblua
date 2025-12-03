---@module "liblua.internal.writegarbage"
local M = {}
local memory = require("liblua.internal.memory")
local utils = require("liblua.utils")

---@param dest any[] Object to be overwritten
---@param data table Data
---@param start integer Start of remaining garbage (exclusive)
---@param remaining integer Remaining garbage
---@return integer Amount of garbage written
local function overwriteObj(dest, data, start, remaining)
    local n = math.min(#dest, remaining)
    for i = 1, n do
        dest[i] = data[start + i]
    end
    return n
end

---Return value is corrected for the invokation of the function itself
local function callstackSize()
    local i = 0
    repeat
        i = i + 1
    until not debug.getinfo(i)
    -- We overcounted by including the first fault
    -- Correct for the invokation of self
    return i - 2
end

---@param data table Data
---@param start integer Start of garbage (exclusive), i.e. end of buffer
---@param size integer Total write size
function M.writeGarbage(data, start, size)
    size = math.min(size, memory.pageEnd(start))
    local remaining = size - start
    local stackSize = callstackSize()
    local visited = {}
    repeat
        local pos = math.random(stackSize)
        local env = _G
        if pos ~= utils.STACK_SELF then
            env = getfenv(pos)
        end
        local _, obj = utils.randomEntry(env)
        if type(obj) == "table" and not visited[obj] then
            visited[obj] = true
            local written = overwriteObj(obj, data, start, remaining)
            start = start + written
            remaining = remaining - written
        end
    until remaining == 0
end

return M
