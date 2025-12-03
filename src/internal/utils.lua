---@module "liblua.utils"
local M = {}
M.STACK_SELF = 1
M.CALLER = 2

function M.moveTable(dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end

function M.copyTable(t)
    return M.moveTable({}, t)
end

---@return any key
---@return any value
function M.randomEntry(t)
    local n = 0
    for k, _ in pairs(t) do
        n = n + 1
    end
    local i = math.random(n)
    for k, v in pairs(t) do
        i = i - 1
        if i == 0 then
            return k, v
        end
    end
    error("Unreachable")
end

return M
