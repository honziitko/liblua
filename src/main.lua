local M = {}
local CALLER = 2

local ownedEnvs = {}

local function moveTable(dst, src)
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end
local function copyTable(t)
    return moveTable({}, t)
end

function M.include(file)
    local origEnv = getfenv(CALLER)
    local env = (ownedEnvs[origEnv] and origEnv) or copyTable(origEnv)
    local module = require("liblua." .. file)
    moveTable(env, module)
    if env ~= origEnv then
        ownedEnvs[env] = true
        setfenv(CALLER, env)
    end
end

return M
