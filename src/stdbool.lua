--[[
NAME
    stdbool_h - Booleans for Lua

SYNOPSIS
    #define bool _Bool
    #define true 1
    #define false 0
    #define __bool_true_false_are_defined 1

DESCRIPTION
    Provides the boolean type.

NOTES
    Deprecated in Lua 5.5.

SEE ALSO
    Full documentation <https://cppreference.com/w/c/header/stdbool.html>

    iso646_h(7)
    ]]

---@module "liblua.stdbool.h"
local M = {}

local versions = require("liblua.internal.versions")
versions.assert(versions.C95, nil)

require("liblua.utils").moveTable(M, require("liblua.intrdef.h"))

M.bool = M._Bool
M.__bool_true_false_are_defined = true

return M
