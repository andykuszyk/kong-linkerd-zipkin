local BasePlugin = require "kong.plugins.base_plugin"
local LinkerdTraceContextHandler = BasePlugin:extend()
require 'kong.plugins.linkerd-trace-context.linkerd'

function LinkerdTraceContextHandler:new()
    LinkerdTraceContextHandler.super.new(self, "linkerd-trace-context")
end

function LinkerdTraceContextHandler:access(config)
    LinkerdTraceContextHandler.super.access(self)

    spanId = get_id(kong.request.get_header("x-b3-spanid"))
    parentId = get_id(kong.request.get_header("x-b3-parentspanid"))
    traceId = get_id(kong.request.get_header("x-b3-traceid"))

header=encode(spanId)..encode(parentId)..encode(traceId)..encode(0)..encode(0)..encode(0)..encode(0)..encode(0)..encode(0)..encode(0)..encode(6)

    kong.service.request.add_header("l5d-ctx-trace", enc(header))
    kong.service.request.add_header("X-foo", enc(header))
end

return LinkerdTraceContextHandler
