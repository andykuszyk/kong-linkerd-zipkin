FROM kong
COPY kong.yml kong.yml
COPY linkerd-trace-context /usr/local/kong/plugins/linkerd-trace-context
ENV KONG_DATABASE=off
ENV KONG_DECLARATIVE_CONFIG=kong.yml
ENV KONG_PLUGINS=linkerd-trace-context,zipkin
ENV KONG_LUA_PACKAGE_PATH=/usr/local/?.lua;;
CMD kong start
