local liblua = require("liblua")
liblua.include("iso646.h")

if liblua.preprocessed() then
    print("returned:", liblua.preprocessedReturn())
    return
end

print("INT_MAX = 2 xor 32 - 1") -- Yeah, it ignores strings and comments
return 42
