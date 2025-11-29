local liblua = require("liblua")
liblua.include("stdarg.h")

local function foo(x, y, ...)
    local ap = va_list()
    va_start(ap, "y")
    for _ = 1, 2 do
        print(va_arg(ap, "number"))
    end
    va_end(ap)
end

foo(1, 2, { 3 }, { 4 })
