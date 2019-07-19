local BasePlugin = require "kong.plugins.base_plugin"
local LinkerdTraceContextHandler = BasePlugin:extend()
require 'kong.plugins.linkerd-trace-context.linkerd'

function LinkerdTraceContextHandler:new()
    LinkerdTraceContextHandler.super.new(self, "linkerd-trace-context")
end

function LinkerdTraceContextHandler:access(config)
    LinkerdTraceContextHandler.super.access(self)

    span_id = get_id(kong.request.get_header("x-b3-spanid"))
    parent_id = get_id(kong.request.get_header("x-b3-parentspanid"))
    trace_id = get_id(kong.request.get_header("x-b3-traceid"))
    flags = 6 

    header = build_header(span_id, parent_id, trace_id, flags)
    
    kong.service.request.add_header("l5d-ctx-trace", enc(header))
    kong.service.request.add_header("X-foo", enc(header))
end

return LinkerdTraceContextHandler
