local Const = require "const"

local function execute(self, tick)
    tick[self] = tick[self] or {}
    if not tick[self].is_open then
        tick[self].is_open = true
        if self.open then
            self:open(tick)
        end
    end
    local status, running = self:run(tick)
    if status == Const.RUNNING then
        return status, running
    else
        tick[self].is_open = false
        if self.close then
            self:close(tick)
        end
        return status
    end
end

return execute
