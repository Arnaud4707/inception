# Makefile
NAME := inception
COMPOSE := docker compose -f srcs/docker-compose.yml
DATA_DIR := /home/amugisha/data

.PHONY: all build up down stop clean logs ps gen-certs nginx-test

all: gen-certs build up

build:
	$(COMPOSE) build

up:
	@echo "Creating persistent data directories..."
	@mkdir -p $(DATA_DIR)/wp $(DATA_DIR)/db
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) down --rmi all --volumes --remove-orphans

clean:
	$(COMPOSE) down --rmi all --volumes --remove-orphans

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

fclean: clean
	docker system prune -a --volumes -f
	rm -rf secrets/certs

re: fclean all

gen-certs:
	mkdir -p secrets/certs
	@if [ ! -f secrets/certs/server.key ] || [ ! -f secrets/certs/server.crt ]; then \
	  echo "Generating self-signed certs in ./secrets/certs..."; \
	  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	    -subj "/CN=amugisha.42.fr" \
	    -keyout secrets/certs/server.key \
	    -out secrets/certs/server.crt; \
	else \
	  echo "secrets/certs/server.key and secrets/certs/server.crt already exist - skipping"; \
	fi

nginx-test:
	$(COMPOSE) exec nginx nginx -t
