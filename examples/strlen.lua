local liblua = require("liblua")
liblua.include("string.h")

local goodStr = "Hello\0"
print('strlen("Hello\\0") =', strlen(goodStr))
local badStr = "Hello"
for i = 1, 3 do
    print('strlen("Hello") =', strlen(badStr))
end

local evilStr = string.rep("A", 4095)
print(strlen(evilStr))
