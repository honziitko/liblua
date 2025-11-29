local M = {}
local utils = require("liblua.utils")

local ownedEnvs = {}

function M.include(file)
    local origEnv = getfenv(utils.CALLER)
    local env = (ownedEnvs[origEnv] and origEnv) or utils.copyTable(origEnv)
    local module = require("liblua." .. file)
    utils.moveTable(env, module)
    if env ~= origEnv then
        ownedEnvs[env] = true
        setfenv(utils.CALLER, env)
    end
end

return M
