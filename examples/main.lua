local liblua = require("liblua")
local stdarg = require("liblua.stdarg.h")

local function foo(x, y, ...)
    local ap = stdarg.va_list()
    stdarg.va_start(ap, "y")
    for _ = 1, 2 do
        print(stdarg.va_arg(ap, "number"))
    end
    stdarg.va_end(ap)
end

foo(1, 2, 67, 41)
