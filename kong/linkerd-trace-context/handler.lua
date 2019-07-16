local BasePlugin = require "kong.plugins.base_plugin"
local LinkerdTraceContextHandler = BasePlugin:extend()

function LinkerdTraceContextHandler:new()
    LinkerdTraceContextHandler.super.new(self, "linkerd-trace-context")
end

function LinkerdTraceContextHandler:access(config)
    LinkerdTraceContextHandler.super.access(self)

    spanId = kong.request.get_header("x-b3-spanid")
    parentId = kong.request.get_header("x-b3-parentspanid")
    traceId = kong.request.get_header("x-b3-traceid")
    header = spanId .. parentId .. traceId .. 0 .. 0 .. 0 .. 0 .. 0 .. 0 .. 0 .. 6

    kong.service.request.add_header("l5d-ctx-trace", enc(header))
    kong.service.request.add_header("X-foo", enc(header))
end

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

return LinkerdTraceContextHandler
