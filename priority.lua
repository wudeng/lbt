local Const = require "const"
local BTCommon = require "bt_common"

local mt = {}
mt.__index = mt

function mt:run(tick)
    for _, node in ipairs(self.children) do
        local status = BTCommon.execute(node, tick)
        if status ~= Const.FAIL then
            return status
        end
    end
    return Const.FAIL
end

local function new(...)
    local obj = {
        name = "priority",
        children = {...},
    }
    setmetatable(obj, mt)
    return obj
end

return new
