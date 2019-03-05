
local Const = require "const"
local BTExec = require "bt_exec"

local mt = {}
mt.__index = mt

function mt:run(tick)
    local status, running = BTExec(self.child, tick)
    if status == Const.RUNNING then
        return status, running
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
