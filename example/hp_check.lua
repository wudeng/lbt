local Const = require "const"

local mt = {}
mt.__index = mt

function mt:run(tick)
    if tick.robot.hp <= self.hp then
        return Const.SUCCESS
    else
        return Const.FAIL
    end
end

local function new(hp)
    local obj = {
        name = "hp_check",
        hp = hp,
    }
    setmetatable(obj, mt)
    return obj
end

return new
