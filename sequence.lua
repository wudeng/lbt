local Const = require "const"
local BTCommon = require "bt_common"

local mt = {}
mt.__index = mt

function mt:run(tick, data)
    for _, node in ipairs(self.children) do
        local status = BTCommon.execute(node, tick, data.__level + 1)
        if status ~= Const.SUCCESS then
            return status
        end
    end
    return Const.SUCCESS
end

function mt:close(tick)
    for _, node in ipairs(self.children) do
        local child_data = tick[node]
        if child_data and child_data.is_open then
            child_data.is_open = false
            if node.close then
                node:close(tick, child_data)
            end
        end
    end
end

local function new(...)
    local obj = {
        name = "sequence",
        children = {...},
    }
    setmetatable(obj, mt)
    return obj
end

return new
