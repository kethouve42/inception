NAME = inception

all: up

up:
	mkdir -p /home/tken66/data
	mkdir -p /home/tken66/data/wordpress
	mkdir -p /home/tken66/data/mariadb
	@docker compose -f ./srcs/docker-compose.yml up --build -d

down:
	@docker compose -f ./srcs/docker-compose.yml down

clean:
	@docker system prune -af
	@docker volume rm $(shell docker volume ls -q)

re: down clean up