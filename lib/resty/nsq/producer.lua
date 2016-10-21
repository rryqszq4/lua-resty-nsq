-- Copyright (c) 2016, rryqszq4

local bit = require "bit"
local cjson = require "cjson"
local conn = require "resty.nsq.conn"

local strchar = string.char
local band = bit.band
local bxor = bit.bxor
local bor = bit.bor
local lshift = bit.lshift
local rshift = bit.rshift
local tohex = bit.tohex

local _M = {
    _VERSION = '0.1'
}

local mt = {
    __index = _M
}

local function _set_byte4(n)
    return strchar(band(n, 0xff),
                   band(rshift(n, 8), 0xff),
                   band(rshift(n, 16), 0xff),
                   band(rshift(n, 24), 0xff))
end

function _split(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end
    
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function _M.new(self, nsqd_tcp_addresses)
    local addr = nsqd_tcp_addresses[1]
    local addr = _split(addr, ":")
    local nsq = conn:new(addr[1], addr[2])
    local conn = nsq:connect()
    
    return setmetatable({
            nsqd_tcp_addresses = nsqd_tcp_addresses,
            nsq = nsq
    }, mt)
end

function _M.pub(self, topic, msg)
    local nsq = self.nsq

    local bytes,err = nsq:send("PUB".." "..topic.."\n"..strchar(#msg)..msg)

    local data, err = nsq:receive()

    ngx.say(err)
    
    --nsq.close()

    return data, err
end

return _M