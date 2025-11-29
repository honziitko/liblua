--[[
NAME
    stdarg.h - Variadic arguments for the Lua language

SYNOPSIS
    typedef /* implementation defined */ va_list;
    /*type*/ va_arg(va_list ap, /*type*/);
    void va_copy(va_list dest, va_list src);
    void va_end(va_list ap);
    void va_start(va_list ap, parmN);

DESCRIPTION
    Enabled access to variadic arguments.

SEE ALSO
    Full documentation <https://cppreference.com/w/c/header/stdarg.html>

    va_list(7), va_copy(3), va_end(3), va_start(3)
--]]

---@module "liblua.stdarg.h"
local M = {}
local utils = require("liblua.utils")
local CALLER = utils.CALLER
local mem = require("liblua.internal.memory")
local readgarbage = require("liblua.internal.readgarbage")

require("liblua.utils").moveTable(M, require("liblua.intrdef.h"))

---@class va_list
---@field package valid boolean
---@field package data any[]
---@field package iterator integer

---@return va_list
function M.va_list()
    local meta = {
        __name = "va_list",
    }
    return setmetatable({}, meta)
end

---@param ap va_list
---@param paramN string
--- void va_start(va_list ap, parmN)
---
--- Initializes a va_list using the last named parameter.
---
--- NOTES
--- Does not conform to the Lua 5.5 revision.
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
--- /\*type\*/ va_arg(va_list ap, /\*type\*/)
---
--- Retrieves an argument from ap. If ap is empty, uninitialized, or
--- /\*type\*/ is not compatible with the value provided, the behaviour
--- is undefined.
function M.va_arg(ap, T)
    if not ap.valid then
        return readgarbage.derefOf(T)
    end
    if ap.iterator > #ap.data then
        return readgarbage.of(T)
    end
    local val = ap.data[ap.iterator]
    ap.iterator = ap.iterator + 1
    return mem.bitcast(val, T)
end

---@param ap va_list
--- void va_end(va_list ap)
---
--- Frees a va_list.
function M.va_end(ap)
    ap.valid = false
end

return M
