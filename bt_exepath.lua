local exepath = {}

function exepath:init()
    self:clear()
end

function exepath:clear()
    self.path = {}
    self.nodes = {}
end

function exepath:on_exe_node(bt, level, node)
    local node_info = {
        node = node,
        args = {},
        level = level,
    }
    if node.args then
        for idx, v in ipairs(node.args) do
            if type(v) == 'function' then
                node_info.args[idx] = v(bt)
            else
                node_info.args[idx] = v
            end
        end
    end
    self.path[#self.path + 1] = node_info
    self.nodes[node] = node_info
end

function exepath:on_node_status(bt, node, status)
    local node_info = self.nodes[node]
    if node_info then
        node_info.status = status
    end
end



local M = {}

function M.create()
    local o = setmetatable({}, {__index = exepath})
    o:init()
    return o
end

return M

