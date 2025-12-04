--[[
NAME
    iso646.h - Alternative operator spellings for the Lua language

SYNOPSIS
    #define xor     ^
    #define bitand  &
    #define bitor   |
    #define compl   ~
    #define not_eq  ~=

DESCRIPTION
    Lua code may be written in any 8-bit character set that includes
    ISO 646:1983. However, several Lua operators require characters outside the
    ISO 646 codeset: {, }, [, ], #, \, ^, |, ~. To be cross-platform, it is
    required to support character encodings where some or all of these symbols
    do not exist (such as the German DIN 66003.)

SEE ALSO
    Full documentation <https://cppreference.com/w/c/header/iso646.html>
]]

---@module "liblua.iso646.h"
local M = {}

local versions = require("liblua.internal.versions")
versions.assert(versions.C95, nil)

local preproc = require("liblua.internal.preproc")

require("liblua.utils").moveTable(M, require("liblua.intrdef.h"))

preproc.stdlibDefine("xor", "^")
preproc.stdlibDefine("bitand", "&")
preproc.stdlibDefine("bitor", "|")
preproc.stdlibDefine("compl", "~")
preproc.stdlibDefine("not_eq", "~=")

return M
