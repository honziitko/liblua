local M = {}

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
    local TClass = classifyType(T)
    local UClass = classifyType(U)
    if TClass == "pointer" and UClass == "value" then
        return M.bitcast(M.addressOf(x), U)
    end
    error(string.format("Unsupported types: %s -> %s", T, U))
end

return M
