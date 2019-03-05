local Const = require "const"
local BTExec = require "bt_exec"

local mt = {}
mt.__index = mt

function mt:open(tick)
    tick[self].runningChild = 1
end

function mt:run(tick)
    local child = tick[self].runningChild
    for i = child, #self.children do
        local status, running = BTExec(self.children[i], tick)
        if status == Const.RUNNING then
            tick[self].runningChild = i
            return status, running
        elseif status == Const.FAIL then
            return status
        end
    end
    return Const.SUCCESS
end

local function new(children)
    local obj = {
        name = "mem_sequence",
        children = children,
    }
    setmetatable(obj, mt)
    return obj
end

return new