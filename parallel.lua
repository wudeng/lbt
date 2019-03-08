local Const = require "const"
local BTCommon = require "bt_common"

local mt = {}
mt.__index = mt

function mt:run(tick)
    local success_count = 0
    local fail_count = 0
    for _, node in ipairs(self.children) do
        local status = BTCommon.execute(node, tick)
        if status == Const.SUCCESS then
            success_count = success_count + 1
            if self.policy == Const.SUCCESS_ONE then
                return Const.SUCCESS
            end
        end
        if status == Const.FAIL then
            fail_count = fail_count + 1
            if self.policy == Const.FAIL_ONE then
                return Const.FAIL
            end
        end
    end

    local all = #self.children

    if self.policy == Const.SUCCESS_ALL and success_count == all then
        return Const.SUCCESS
    end

    if self.policy == Const.FAIL_ALL and fail_count == all then
        return Const.FAIL
    end

    return Const.RUNNING
end

function mt:close(tick)
    for _, node in ipairs(self.children) do
        if tick[node] and tick[node].is_open then
            tick[node].is_open = false
            if node.close then
                node:close(tick)
            end
        end
    end
end

local function new(policy, ...)
    local obj = {
        name = "parallel",
        policy = policy,
        children = {...},
    }
    setmetatable(obj, mt)
    return obj
end

return new
