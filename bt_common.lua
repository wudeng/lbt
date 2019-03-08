local Const = require "const"

local M = {}

local function st2str(status)
    if status == Const.SUCCESS then
        return "SUCCESS"
    elseif status == Const.FAIL then
        return "FAIL"
    else
        return "RUNNING"
    end
end

function M.execute(node, tick)
    tick[node] = tick[node] or {}

    -- open callback
    if not tick[node].is_open then
        if node.open then
            if node:open(tick) == false then
                return Const.FAIL
            end
        end
        tick[node].is_open = true
    end

    -- run callback, get status
    local status = node:run(tick)

    -- debug output
    if tick.log and not node.children then
        tick.log("btnode:", node.name, st2str(status))
    end

    -- close callback
    if status == Const.RUNNING then
        tick.open_nodes[node] = true
        return status
    else
        tick[node].is_open = false
        if node.close then
            node:close(tick)
        end
        return status
    end
end

return M
