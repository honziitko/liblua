package = "liblua"
version = "0.1.0-1"
source = {
    url = "git+https://github.com/honziitko/liblua"
}
description = {
    summary = "Better standard library for Lua (including math)",
    homepage = "https://github.com/honziitko/liblua",
    license = "MIT"
}
dependencies = {
    "lua ~> 5.1"
}
build = {
    type = "builtin",
    modules = {
        liblua = "src/main.lua",
        ["liblua.stdarg.h"] = "src/stdarg.lua",
        ["liblua.utils"] = "src/internal/utils.lua",
        ["liblua.internal.memory"] = "src/internal/memory.lua",
    }
}
