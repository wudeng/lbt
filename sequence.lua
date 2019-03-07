local Const = require "const"
local BTExec = require "bt_exec"

local mt = {}
mt.__index = mt

function mt:run(tick)
    for _, v in ipairs(self.children) do
        local status, running = BTExec(v, tick)
        if status == Const.RUNNING then
            return status, running
        elseif status == Const.FAIL then
            return status
        end
    end
    return Const.SUCCESS
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
