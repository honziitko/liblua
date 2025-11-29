---@module "liblua.internal.readgarbage"
local M = {}
local mem = require("liblua.internal.memory")

local WORD_SIZE = 8
local CHAR_BIT = 8
local SIZE_MAX = 2 ^ (WORD_SIZE * CHAR_BIT)

---@return integer
local function int()
    -- Generate integer short by short because math.random accepts int
    local chunkBits = 16
    local chunkMax = 2 ^ chunkBits
    local n = WORD_SIZE * CHAR_BIT / chunkBits
    local out = 0
    for i = 0, n - 1 do
        out = out + math.random(0, chunkMax - 1) * 2 ^ (i * chunkBits)
    end
    return out
end

---@return integer
local function size()
    local out = 0
    for i = 1, 4 do
        out = out + math.random(16)
    end
    return out
end

---@return boolean
local function bool()
    return math.random(256) > 1
end

---@return string
local function str()
    local bytes = {}
    local n = size()
    for i = 1, n do
        bytes[i] = math.random(256) - 1
    end
    return string.char(unpack(bytes))
end

---@return integer | string | boolean
function M.value()
    local typ = math.random(3)
    if typ == 1 then
        return int()
    elseif typ == 2 then
        return str()
    elseif typ == 3 then
        return bool()
    end
end

---@param T string
---@return any
function M.of(T)
    if T == "number" then
        return int()
    elseif T == "string" then
        return str()
    elseif T == "boolean" then
        return bool()
    elseif T == "table" then
        local n = size()
        local out = {}
        for i = 1, n do
            out[i] = M.value()
        end
        return out
    else
        error("Unsupported type: " .. T)
    end
end

---@param T string
---@return any
function M.derefOf(T)
    if math.random() > 0.5 then
        error(mem.SEGFAULT)
    end
    return M.of(T)
end

return M
