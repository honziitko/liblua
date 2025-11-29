---@module liblua.internal.versions
local M = {}

M.C89 = "1.0"
M.C90 = M.C89
M.C95 = "2.1"
M.C99 = "3.2"
M.C11 = "5.2"
M.C17 = "5.4"
M.C23 = "5.5"

---@param s string
---@return integer | nil
---@return integer | nil
local function parseVersion(s)
    local major, minor = string.match(s, "(%d+)%.(%d+)")
    if not major or not minor then
        return nil
    end
    return tonumber(major), tonumber(minor)
end

---@param x number
---@param y number
---@return -1 | 0 | 1
local function compareNumber(x, y)
    if x < y then
        return -1
    elseif x > y then
        return 1
    else
        return 0
    end
end

---@param x1 number
---@param x2 number
---@param y1 number
---@param y2 number
---@return -1 | 0 | 1
local function comparePair(x1, x2, y1, y2)
    local ord1 = compareNumber(x1, y1)
    if ord1 ~= 0 then return ord1 end
    return compareNumber(x2, y2)
end

---Checks whether a version ver is on the interval [low, high)
---If nil, no condition is checked.
---@param low string | nil
---@param high string | nil
---@param ver string
---@return boolean
function M.between(low, high, ver)
    local verMaj, verMin = parseVersion(ver)
    assert(verMaj and verMin, string.format("`%s` is not a version", ver))
    if low then
        local lowMaj, lowMin = parseVersion(low)
        assert(lowMaj and lowMin, string.format("`%s` is not a version", low))
        if comparePair(lowMaj, lowMin, verMaj, verMin) > 0 then
            return false
        end
    end
    if high then
        local highMaj, highMin = parseVersion(high)
        assert(highMaj and highMin, string.format("`%s` is not a version", high))
        if comparePair(highMaj, highMin, verMaj, verMin) <= 0 then
            return false
        end
    end
    return true
end

---Asserts that the version is on the interval [low, high)
---If nil, no condition is checked.
---@param low string | nil
---@param high string | nil
---@param assumed? string
function M.assert(low, high, assumed)
    local ver = assumed or _VERSION
    assert(M.between(low, high, ver),
        string.format("Must use Lua version between %s and %s", low or "any", high or "any"))
end

return M
