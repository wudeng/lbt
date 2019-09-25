local Const = require "const"
local BTCommon = require "bt_common"

local mt = {}
mt.__index = mt

function mt:run(tick, data)
    if self.child then
        local status = BTCommon.execute(self.child, tick, data.__level + 1)
        if status == Const.RUNNING then
            return status
        else
            return Const.FAIL
        end
    end
    return Const.FAIL
end

function mt:close(tick)
    if self.child then
        local node = self.child
        local node_data = tick[node]
        if node_data and node_data.is_open then
            node_data.is_open = false
            if node.close then
                node:close(tick, node_data)
            end
        end
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
