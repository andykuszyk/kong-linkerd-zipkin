local BasePlugin = require "kong.plugins.base_plugin"
local LinkerdTraceContextHandler = BasePlugin:extend()

function LinkerdTraceContextHandler:new()
    LinkerdTraceContextHandler.super.new(self, "linkerd-trace-context")
end

function LinkerdTraceContextHandler:access(config)
    LinkerdTraceContextHandler.super.access(self)
    
    kong.service.request.add_header("X-Foo", "Bar")
end

return LinkerdTraceContextHandler
