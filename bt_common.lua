local Const = require "const"

local M = {}

local function _open(node, tick)
    if not tick[node].is_open then
        tick[node].is_open = true
        if node.open then
            node:open(tick)
        end
    end
end

local function _close(node, tick)
    tick[node].is_open = false
    if node.close then
        node:close(tick)
    end
end

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
    _open(node, tick)
    local status = node:run(tick)
    if tick.log and not node.children then
        tick.log("btnode:", node.name, st2str(status))
    end
    if status == Const.RUNNING then
        tick.open_nodes[node] = true
        return status
    else
        _close(node, tick)
        return status
    end
end

function M.open(node, tick)
    _open(node, tick)
end

function M.close(node, tick)
    _close(node, tick)
end

return M
