local Const = require "const"
local BTCommon = require "bt_common"

local mt = {}
mt.__index = mt

function mt:run(tick)
    local status = BTCommon.execute(self.child, tick)
    if status == Const.RUNNING then
        return status
    else
        return Const.FAIL
    end
end

local function new(node)
    local obj = {
        name = "always_fail",
        child = node,
    }
    setmetatable(obj, mt)
    return obj
end

return new
