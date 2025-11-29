local M = {}
M.CALLER = 2

function M.moveTable(dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end

function M.copyTable(t)
    return M.moveTable({}, t)
end

return M
