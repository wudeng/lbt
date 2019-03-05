local BTExec = require "bt_exec"

local M = {}

local mt = {}
mt.__index = mt

M.priority  = require("priority")
M.sequence  = require("sequence")
M.invert    = require("invert")
M.mem_sequence  = require("mem_sequence")
M.mem_priority  = require("mem_priority")
M.always_succeed= require("always_succeed")
M.always_fail   = require("always_fail")

function mt:tick()
    local _, running = BTExec(self.root, self)
    local lastRunning = self.running
    if lastRunning and lastRunning ~= running then
        if self[lastRunning].is_open then
            lastRunning:close()
        end
    end
    self.running = running
end

-- tick 实例：保存树的状态和黑板, [node] -> {is_open:boolean, ...}
function M.new(robot, root)
    local obj = {
        running = nil,      -- 记录上一次的运行节点
        robot = robot,
        root = root,
    }
    setmetatable(obj, mt)
    return obj
end

return M
