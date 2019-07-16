build:
	docker-compose up -d --force-recreate --build

start:
	docker-compose up -d

stop:
	docker-compose down
	docker rm -f $$(docker container ls -a | grep konglinkerdzipkin | awk '{print $$1}') || true

request:
	curl localhost:8000 -v | jq

restart: stop build

wait:
	sleep 5

test: restart wait request
