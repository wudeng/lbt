local Const = require "const"
local BTExec = require "bt_exec"

local mt = {}
mt.__index = mt

function mt:run(tick)
    for _, v in ipairs(self.children) do
        local status, running = BTExec(v, tick)
        if status == Const.RUNNING then
            return status, running
        elseif status == Const.SUCCESS then
            return status
        end
    end
    return Const.FAIL
end

local function new(children)
    local obj = {
        name = "priority",
        children = children,
    }
    setmetatable(obj, mt)
    return obj
end

return new
