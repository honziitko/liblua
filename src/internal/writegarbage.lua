---@module "liblua.internal.writegarbage"
local M = {}
local memory = require("liblua.internal.memory")
local utils = require("liblua.utils")
local readgarbage = require("liblua.internal.readgarbage")

local function isArrayIndex(x)
    if type(x) ~= "number" then return false end
    if x < 1 then return false end
    return x % 1 == 0
end

---@enum TableType
local TableType = {
    array = 1,
    hashmap = 2,
}

---@return TableType
local function classifyTable(t)
    local size = #t
    local occupancy = 0
    for i = 1, size do
        if t[i] ~= nil then
            occupancy = occupancy + 1
        end
    end
    if size > 0 and (occupancy / size) < 0.4 then
        -- Likely a map with integers as keys
        return TableType.hashmap
    end
    local numNonArrayKeys = 0
    for k, v in pairs(t) do
        if not isArrayIndex(k) then
            numNonArrayKeys = numNonArrayKeys + 1
        end
    end
    if size < numNonArrayKeys then
        return TableType.hashmap
    end
    if size > numNonArrayKeys then
        return TableType.array
    end
    return math.random(2)
end

---@param dest any[] Object to be overwritten
---@param data table Data
---@param start integer Start of remaining garbage (exclusive)
---@param remaining integer Remaining garbage
---@return integer Amount of garbage written
local function overwriteObj(dest, data, start, remaining)
    local class = classifyTable(dest)
    if class == TableType.array then
        local n = math.min(#dest, remaining)
        for i = 1, n do
            dest[i] = data[start + i]
        end
        return n
    elseif class == TableType.hashmap then
        local pairsAvailableDest = 0
        local tailKey = nil
        for key, _ in pairs(dest) do
            if remaining < (pairsAvailableDest + 1) then
                tailKey = key
                break
            end
            dest[key] = nil
            pairsAvailableDest = pairsAvailableDest + 1
        end
        local pairsAvailableSrc = math.floor(remaining / 2)
        local pairsAvailable = math.min(pairsAvailableDest, pairsAvailableSrc)
        for i = 1, 2 * pairsAvailable - 1, 2 do
            local newKey = data[start + i]
            local newVal = data[start + i + 1]
            dest[newKey] = newVal
        end
        if remaining % 2 ~= 0 then
            local i = 0
            local writtenKey = data[start + remaining]
            if tailKey then
                dest[writtenKey] = dest[tailKey]
                dest[tailKey] = nil
            else
                dest[writtenKey] = readgarbage.value()
            end
        end
        return remaining
    else
        error("Unreachable")
    end
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
