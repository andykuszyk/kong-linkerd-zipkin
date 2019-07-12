start:
	docker-compose up -d

stop:
	docker-compose down
	docker rm -f $$(docker container ls -a | grep konglinkerdzipkin | awk '{print $$1}')
