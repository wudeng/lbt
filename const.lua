local mt = {}

mt.__index = function()
    error("invalid return value")
end

return setmetatable({
    SUCCESS = 1,
    FAIL    = 2,
    RUNNING = 3,
}, mt)
