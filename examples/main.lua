local liblua = require("liblua")
liblua.include("stdarg.h")

local function foo(x, ...)
    local ap = va_list()
    va_start(ap, "x")
    for _ = 1, 5 do
        print(va_arg(ap, "string"))
    end
    va_end(ap)
end

local function bar(x, ...)
    local ap = va_list()
    va_start(ap, "x")
    for _ = 1, 2 do
        print(va_arg(ap, "number"))
    end
    va_end(ap)
end

foo("A", "B", "C", "D")
print("AAA")
bar("A", { 2 }, foo, false)
