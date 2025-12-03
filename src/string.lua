--[[
NAME
    string_h - A string library for Lua

SYNOPSIS
    size_t strlen(const char *s)
    void *memset(void *s, char c, size_t n)

DESCRIPTION
    A string library for Lua. Strings are defined to be a sequence
    of characters terminated by a null byte (\0), as described by
    ISO/IEC 9899:TC3 section 7.1.1.

NOTES
    These functions, unless stated to the contrary, do not check for
    length. If the string is not null-terminated, or the size
    parameter exceeds the capacity, the behaviour is undefined.

SEE ALSO
    Full documentation <https://en.cppreference.com/w/c/header/string.html>

    strlen(3)
    ]]
---@module "liblua.string.h"
local M = {}
local memory = require("liblua.internal.memory")

require("liblua.utils").moveTable(M, require("liblua.intrdef.h"))

function M.strlen(s)
    local defined = string.find(s, "\0")
    if defined then
        return defined - 1
    end
    local pageEnd = memory.pageEnd(#s)
    for i = #s + 1, pageEnd do
        if math.random(256) == 1 then
            return i - 1
        end
    end
    error(memory.SEGFAULT)
end

function M.memset(s, c, n)
    assert(n <= #s, "Specified size exceeds real size")
    for i = 1, n do
        s[i] = c
    end
    return s
end

return M
