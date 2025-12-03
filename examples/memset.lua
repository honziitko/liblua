local liblua = require("liblua")
liblua.include("string.h")

local function array(n, elem)
    local out = {}
    for i = 1, n do
        out[i] = elem
    end
    return out
end

local dest = array(4, 0)

print(table.concat(dest, ", "))
memset(dest, 42, #dest)
print(table.concat(dest, ", "))
