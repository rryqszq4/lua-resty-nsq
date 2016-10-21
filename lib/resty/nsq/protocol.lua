-- Copyright (c) 2016, rryqszq4

local strbyte = string.byte

local _M = {}
local mt = { __index = _M }

function _command(cmd, body)
end

function _M.new(self)
    return setmetatable({
            
    }, mt)
end



return _M