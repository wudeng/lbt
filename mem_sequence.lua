local Const = require "const"
local BTCommon = require "bt_common"

local mt = {}
mt.__index = mt

function mt:open(_, node_data)
    node_data.runningChild = 1
end

function mt:run(tick, node_data)
    local child = node_data.runningChild
    for i = child, #self.children do
        local status = BTCommon.execute(self.children[i], tick)
        if status == Const.FAIL then
            return status
        end
        if status == Const.RUNNING then
            node_data.runningChild = i
            return status
        end
    end
    return Const.SUCCESS
end

function mt:close(_, node_data)
    node_data.runningChild = 1
end

local function new(...)
    local obj = {
        name = "mem_sequence",
        children = {...},
    }
    setmetatable(obj, mt)
    return obj
end

return new
