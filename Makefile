.PHONY: all app server domain

all: server app

domain:
	docker compose build domain

app: domain
	docker compose build webapp

server: domain
	docker compose build server cigogne squirrel

run_server: server
	docker compose up -d db server
