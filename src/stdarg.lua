local M = {}

local CALLER = 2

---@class va_list
---@field private valid boolean
---@field private data any[]
---@field private iterator integer

---@return va_list
function M.va_list()
    local meta = {
        __name = "va_list",
    }
    return setmetatable({}, meta)
end

---@param ap va_list
---@param paramN string
function M.va_start(ap, paramN)
    ap.valid = true
    ap.iterator = 1
    local i = 1
    while true do
        local name, val = debug.getlocal(CALLER, i)
        assert(name, string.format("No parameter %s exists", paramN))
        i = i + 1
        if name == paramN then
            local varname, varval = debug.getlocal(CALLER, i)
            assert(varname and type(varval) == "table", "Function is not variadic")
            ap.data = varval
            break
        end
    end
end

---@param ap va_list
---@param T string
---@return any
function M.va_arg(ap, T)
    assert(ap.valid)
    assert(ap.iterator <= #ap.data)
    local val = ap.data[ap.iterator]
    ap.iterator = ap.iterator + 1
    assert(type(val) == T)
    return val
end

---@param ap va_list
function M.va_end(ap)
end

return M
