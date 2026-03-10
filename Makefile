# Makefile
NAME := Inception
COMPOSE := docker compose -f srcs/docker-compose.yml
DATA_DIR := /home/amugisha/data

.PHONY: all build up down clean logs ps gen-certs fclean re

all: gen-certs build up

build:
	$(COMPOSE) build

up:
	@echo "Creating persistent data directories..."
	@mkdir -p $(DATA_DIR)/wp $(DATA_DIR)/mariadb
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --rmi all --volumes --remove-orphans

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

fclean: clean
	docker system prune -a --volumes -f
	rm -rf srcs/requirements/nginx/certs

re: fclean all

gen-certs:
	mkdir -p srcs/requirements/nginx/certs
	@if [ ! -f srcs/requirements/nginx/certs/server.key ] || [ ! -f srcs/requirements/nginx/certs/server.crt ]; then \
	  echo "Generating self-signed certs in ./srcs/requirements/nginx/certs..."; \
	  openssl req -x509 -noenc -days 365 -newkey rsa:2048 \
	    -subj "/CN=amugisha.42.fr" \
	    -keyout srcs/requirements/nginx/certs/server.key \
	    -out srcs/requirements/nginx/certs/server.crt; \
	else \
	  echo "srcs/requirements/nginx/certs/server.key and srcs/requirements/nginx/certs/server.crt already exist - skipping"; \
	fi
