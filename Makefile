.PHONY: all app server domain

all: server app

run_all: run_server run_app

domain:
	docker compose build domain

app: domain
	docker compose build webapp

run_app: app
	docker compose up -d webapp

server: domain
	docker compose build server cigogne squirrel

run_server: server
	docker compose up -d db server
