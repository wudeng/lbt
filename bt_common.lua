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

function M.execute(node, tick)
    tick[node] = tick[node] or {}
    _open(node, tick)
    local status, running = node:run(tick)
    if status == Const.RUNNING then
        return status, running or node
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
