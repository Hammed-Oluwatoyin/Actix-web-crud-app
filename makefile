DB_DOCKER_CONTAINER=youtube_postgres_container


install:
# uncomment and indent
	cargo install cargo-edit
	cargo add actix-web
	cargo add actix-cors
	cargo add serde_json
	cargo add serde --features derive
	cargo add chrono --features serde
	cargo add env_logger
	cargo add dotenv
	cargo add uuid --features "serde v4"
	cargo add sqlx --features "runtime-async-std-native-tls postgres chrono uuid"
	cargo add jsonWebToken
	cargo add argon2
	cargo add rand_core --features 'std'

# SQLX-CLI
	cargo install sqlx-cli
create_migrations:
	sqlx migrate add -r init

migrate-up:
	sqlx migrate run

migrate-down:
	sqlx migrate revert



stop_containers:
	@echo "Stoping all docker containers..."
	if [ $$(docker ps -q) ]; then \
		echo "found and stopped containers..."; \
		docker stop $$(docker ps -q); \
	else \
		echo "no active containers found..."; \
	fi

create_docker_container:
	docker run --name ${DB_DOCKER_CONTAINER} -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

create_postgres_db:
	docker exec -it ${DB_DOCKER_CONTAINER} createdb --username=root --owner=root soccerrustydb

start_docker_db:
	docker start ${DB_DOCKER_CONTAINER}

run:
	cargo run

init_docker: stop_containers start_docker_db