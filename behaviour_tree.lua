local BtExec = require("bt_exec")

local mt = {}
mt.__index = mt

function mt:tick()
    local _, running = BtExec(self.root, self)
    local lastRunning = self.running
    if lastRunning and lastRunning ~= running then
        if self[lastRunning].is_open then
            lastRunning:close()
        end
    end
    self.running = running
end

-- tick 实例：保存树的状态和黑板, [node] -> {is_open:boolean, ...}
local function new(robot, root)
    local obj = {
        running = nil,      -- 记录上一次的运行节点
        robot = robot,
        root = root,
    }
    setmetatable(obj, mt)
    return obj
end

return new
