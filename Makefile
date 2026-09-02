NAME = inception

all:
	@printf "Launch configuration ${NAME}...\n"
	@docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	@printf "Stopping configuration ${NAME}...\n"
	@docker compose -f ./srcs/docker-compose.yml down

clean: down
	@printf "Cleaning configuration ${NAME}...\n"
	@docker system prune -a --force

fclean:
	@printf "Total clean of all configurations docker\n"
	@docker compose -f ./srcs/docker-compose.yml down -v
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf /home/achowdhu/data/wordpress/*
	@sudo rm -rf /home/achowdhu/data/mariadb/*

re: fclean all

.PHONY: all down clean fclean re
