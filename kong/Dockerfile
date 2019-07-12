FROM kong
COPY kong.yml kong.yml
ENV KONG_DATABASE=off
ENV KONG_DECLARATIVE_CONFIG=kong.yml
CMD kong start
