---@module "liblua"
local M = {}
local utils = require("liblua.utils")
local preporc = require("liblua.internal.preproc")
M.preprocessed = preporc.preprocessed
M.preprocessedReturn = preporc.returnValue

local ownedEnvs = {}

function M.include(file)
    local origEnv = getfenv(utils.CALLER)
    local env = (ownedEnvs[origEnv] and origEnv) or utils.copyTable(origEnv)
    local module
    if file == "iso646.h" then
        module = dofile("src/iso646.lua")
    else
        module = require("liblua." .. file)
    end
    utils.moveTable(env, module)
    if env ~= origEnv then
        ownedEnvs[env] = true
        setfenv(utils.CALLER, env)
    end
end

return M
