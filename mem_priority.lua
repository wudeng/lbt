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
        elseif status == Const.SUCCESS then
            return status
        end
    end
    return Const.FAIL
end

local function new(...)
    local obj = {
        name = "mem_priority",
        children = {...},
    }
    setmetatable(obj, mt)
    return obj
end

return new
