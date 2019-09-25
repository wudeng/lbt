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


function M.execute(node, tick, level)
    local node_data = tick[node] or {}
    node_data.__level = level
    tick[node] = node_data

    if tick.log then
        tick.exepath:on_exe_node(tick, level, node)
    end

    -- open callback
    if not node_data.is_open then
        if node.open then
            local ret = node:open(tick, node_data)
            if ret then
                if tick.log then
                    tick.exepath:on_node_status(node, st2str(ret))
                end
                return ret
            end
        end
        node_data.is_open = true
    end

    -- run callback, get status
    local status = node:run(tick, node_data)
    if tick.log then
        tick.exepath:on_node_status(tick, node, st2str(status))
    end

    -- close callback
    if status == Const.RUNNING then
        tick.open_nodes[node] = true
        return status
    else
        node_data.is_open = false
        if node.close then
            node:close(tick, node_data)
        end
        return status
    end
end

-- 根据权重决定子节点索引的顺序
function M.reorder(indexes, weight, total)
    for i = 1, #indexes do
        local rnd = math.random(total)
        local acc = 0
        for j = i, #indexes do
            local w = weight[indexes[j]]
            acc = acc + w
            if rnd <= acc then
                indexes[i], indexes[j] = indexes[j], indexes[i]
                total = total - w
                break
            end
        end
    end
end

return M
