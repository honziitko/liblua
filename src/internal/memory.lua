---@module "liblua.internal.memory"
local M = {}
M.readgarbage = require("liblua.internal.readgarbage")

M.PAGESIZE = 4096 -- 4 kB

---@param addr integer
---@return integer
function M.pageEnd(addr)
    return M.PAGESIZE * math.ceil(addr / M.PAGESIZE)
end

function M.addressOf(x)
    return tonumber(tostring(x):match("0x%x+"))
end

---@param T string
---@return "pointer" | "value"
local function classifyType(T)
    if T == "number" or T == "boolean" then
        return "value"
    end
    if T == "table" or T == "function" then
        return "pointer"
    end
    error("Unknown/unsupported type: " .. T)
end

---@param x any
---@param U string
function M.bitcast(x, U)
    local T = type(x)
    if T == U then
        return x
    end
    if T == "number" and U == "boolean" then
        return x ~= 0
    end
    if T == "boolean" and U == "number" then
        return (x and 1) or 0
    end
    local TClass = classifyType(T)
    local UClass = classifyType(U)
    if TClass == "pointer" and UClass == "value" then
        return M.bitcast(M.addressOf(x), U)
    end
    error(string.format("Unsupported types: %s -> %s", T, U))
end

return M
