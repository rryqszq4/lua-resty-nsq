-- Copyright (c) 2016, rryqszq4

local tcp = ngx.socket.tcp

local _M = {}
local mt = { __index = _M }

function _M.new(self, host, port)
    local sock, err = tcp()
    return setmetatable({
        sock = sock,
        host = host,
        port = port
    }, mt)
end

function _M.connect(self)
    local sock = self.sock
    if not sock then
        return nil, err
    end

    local ok, err = sock:connect(self.host, self.port)
    if not ok then
        return nil, err
    end

    return ok, err
end

function _M.send(self, data)
    local sock = self.sock

    local bytes, err = sock:send(data)
    if not bytes then
        return nil, err
    end

    return bytes, err
end

function _M.receive(self)
    local sock = self.sock

    local data, err = sock:receive()
    if not data then
        return nil, err
    end

    return data,err
end

function _M.close(self)
    local sock = self.sock
    if not sock then
        return nil, "not initialized"
    end

    return sock:close()
end

return _M